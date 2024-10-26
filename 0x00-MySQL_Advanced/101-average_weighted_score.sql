-- Creates a stored procedure ComputeAverageWeightedScoreForUsers that computes and store the average weighted score for all students
DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    DECLARE user_id INT;
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE average_weighted FLOAT;
    DECLARE num_users INT DEFAULT 0;
    DECLARE current_index INT DEFAULT 0;

    -- Get the total number of users
    SELECT COUNT(*) INTO num_users FROM users;

    WHILE current_index < num_users DO
        -- Get the user ID for the current index
        SELECT id INTO user_id
        FROM users
        ORDER BY id
        LIMIT 1 OFFSET current_index;

        -- Calculate total weighted score and total weight for this user
        SELECT 
            SUM(c.score * p.weight) INTO total_score,
            SUM(p.weight) INTO total_weight
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;

        -- Calculate the average weighted score if total_weight is not zero
        IF total_weight > 0 THEN
            SET average_weighted = total_score / total_weight;
        ELSE
            SET average_weighted = 0;
        END IF;

        -- Update the user's average_score
        UPDATE users SET average_score = average_weighted WHERE id = user_id;

        -- Increment the current index
        SET current_index = current_index + 1;
    END WHILE;
END$$

DELIMITER ;

