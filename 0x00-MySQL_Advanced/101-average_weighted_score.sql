-- create procedure
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    
    -- Cursor to iterate over all users
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN user_cursor;

    -- Loop through each user
    user_loop: LOOP
        FETCH user_cursor INTO user_id;
        IF done THEN
            LEAVE user_loop;
        END IF;

        -- Variables to store numerator and denominator
        DECLARE total_weight INT DEFAULT 0;
        DECLARE total_weighted_score FLOAT DEFAULT 0;

        -- Calculate total weighted score for the current user
        SELECT SUM(c.score * p.weight) INTO total_weighted_score
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;

        -- Calculate total weight for the current user
        SELECT SUM(p.weight) INTO total_weight
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;

        -- Update user's average_score based on the total_weight and total_weighted_score
        IF total_weight > 0 THEN
            UPDATE users SET average_score = total_weighted_score / total_weight WHERE id = user_id;
        ELSE
            UPDATE users SET average_score = 0 WHERE id = user_id;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE user_cursor;
END $$

DELIMITER ;

