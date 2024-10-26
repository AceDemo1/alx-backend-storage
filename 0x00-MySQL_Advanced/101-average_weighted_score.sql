-- Create procedure ComputeAverageWeightedScoreForUser to calculate the average weighted score for each user

DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

CREATE PROCEDURE ComputeAverageWeightedScoreForUser()
BEGIN
    DECLARE NUM FLOAT DEFAULT 0;  -- Total weighted score
    DECLARE DEMU FLOAT DEFAULT 0;  -- Total weight
    DECLARE user_id INT;
    DECLARE total_users INT DEFAULT 0;

    -- Get the total number of users
    SELECT COUNT(*) INTO total_users FROM users;

    -- Loop through each user based on their ID
    WHILE total_users > 0 DO
        -- Get the user ID
        SELECT id INTO user_id 
        FROM users 
        ORDER BY id 
        LIMIT 1 OFFSET total_users - 1;

        -- Calculate the numerator (total weighted score) for the user
        SELECT COALESCE(SUM(c.score * p.weight), 0) INTO NUM
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;

        -- Calculate the denominator (total weight) for the user
        SELECT COALESCE(SUM(p.weight), 0) INTO DEMU
        FROM projects p
        JOIN corrections c ON p.id = c.project_id
        WHERE c.user_id = user_id;

        -- Update the user's average_score based on the calculated values
        IF DEMU > 0 THEN
            UPDATE users SET average_score = NUM / DEMU WHERE id = user_id;
        ELSE
            UPDATE users SET average_score = 0 WHERE id = user_id;
        END IF;

        -- Decrement the total_users count to process the next user
        SET total_users = total_users - 1;

        -- Reset NUM and DEMU for the next iteration
        SET NUM = 0;
        SET DEMU = 0;
    END WHILE;
END $$

DELIMITER ;

