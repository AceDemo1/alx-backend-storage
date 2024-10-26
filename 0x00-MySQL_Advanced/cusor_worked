-- create 
DELIMITER $$
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE current_user_id INT;
    DECLARE total_weight FLOAT;
    DECLARE total_score FLOAT;
    DECLARE average_weighted FLOAT;
    
    -- Define a cursor for user IDs
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN user_cursor;

    user_loop: LOOP
        FETCH user_cursor INTO current_user_id;
        IF finished THEN
            LEAVE user_loop;
        END IF;

        -- Reset values for each user
        SET total_weight = 0;
        SET total_score = 0;
        SET average_weighted = 0;

        -- Calculate the weighted score and total weight
        SELECT 
            SUM(c.score * p.weight), SUM(p.weight) 
        INTO 
            total_score, total_weight
        FROM 
            corrections c
        JOIN 
            projects p ON c.project_id = p.id
        WHERE 
            c.user_id = current_user_id;

        -- Only calculate average if total_weight is non-zero
        IF total_weight > 0 THEN
            SET average_weighted = total_score / total_weight;
        END IF;

        -- Update the user's average score
        UPDATE users SET average_score = average_weighted WHERE id = current_user_id;
    END LOOP;

    CLOSE user_cursor;
END$$
DELIMITER ;

