DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE average_weighted FLOAT;

    -- Declare a cursor to iterate over each user
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN user_cursor;

    read_loop: LOOP
        FETCH user_cursor INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the total weighted score and total weight for this user
        SELECT SUM(c.score * p.weight), SUM(p.weight) INTO total_score, total_weight
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
    END LOOP;

    CLOSE user_cursor;
END$$

DELIMITER ;

