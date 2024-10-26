-- Create procedure ComputeAverageWeightedScoreForUser to calculate the average weighted score for each user

DELIMITER $

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

CREATE PROCEDURE ComputeAverageWeightedScoreForUser()
BEGIN
    DECLARE NUM FLOAT;
    DECLARE DEMU FLOAT;
    DECLARE user_id INT DEFAULT 1;
    DECLARE total_users INT DEFAULT 0;

    -- Get the total number of users
    SELECT COUNT(*) INTO total_users FROM users;

    -- Loop through each user based on their ID
    WHILE user_id <= total_users DO
        -- Calculate the numerator (total weighted score) for the user
        SELECT SUM(score * weight) INTO NUM
        FROM corrections  
        JOIN projects ON corrections.project_id = projects.id   
        WHERE corrections.user_id = user_id;

        -- Calculate the denominator (total weight) for the user
        SELECT SUM(weight) INTO DEMU
        FROM projects
        JOIN corrections ON projects.id = corrections.project_id
        WHERE corrections.user_id = user_id;

        -- Update the user's average_score based on the calculated values
        IF DEMU <= 0 THEN
            UPDATE users SET average_score = 0 WHERE id = user_id;  
        ELSE
            UPDATE users SET average_score = NUM / DEMU WHERE id = user_id;
        END IF;

        -- Increment the user_id to proceed to the next user
        SET user_id = user_id + 1;
    END WHILE;
END $

DELIMITER ;

