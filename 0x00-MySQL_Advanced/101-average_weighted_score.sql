-- create procedure
DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

CREATE PROCEDURE ComputeAverageWeightedScoreForUser()
BEGIN
    DECLARE NUM FLOAT DEFAULT 0;
    DECLARE DEMU FLOAT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE i INT DEFAULT 0;
    DECLARE total_users INT DEFAULT 0;

    -- Get the total number of users
    SELECT COUNT(*) INTO total_users FROM users;

    -- Loop through each user based on their index
    WHILE i < total_users DO
        -- Get the user ID for the current index
        SELECT id INTO user_id FROM users
        ORDER BY id
        LIMIT 1 OFFSET i;

        -- Calculate the numerator (total weighted score) for the user
        SELECT COALESCE(SUM(score * weight), 0) INTO NUM
        FROM corrections
        JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate the denominator (total weight) for the user
        SELECT COALESCE(SUM(weight), 0) INTO DEMU
        FROM projects
        JOIN corrections ON projects.id = corrections.project_id
        WHERE corrections.user_id = user_id;

        -- Update the user's average_score based on the calculated values
        IF DEMU = 0 THEN
            UPDATE users SET average_score = 0 WHERE id = user_id;
        ELSE
            UPDATE users SET average_score = NUM / DEMU WHERE id = user_id;
        END IF;

        -- Increment the index variable to proceed to the next user
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

