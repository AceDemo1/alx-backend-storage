-- create
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE userId INT;
    DECLARE weightedAverage FLOAT;

    -- Declare a cursor to iterate over all users
    DECLARE user_cursor CURSOR FOR 
        SELECT id FROM users;

    -- Declare a continue handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN user_cursor;

    read_loop: LOOP
        -- Fetch the next user id
        FETCH user_cursor INTO userId;
        
        -- If no more users, exit the loop
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the weighted average score for the current user
        SELECT 
            SUM(c.score * p.weight) / SUM(p.weight) INTO weightedAverage
        FROM 
            corrections c
        JOIN 
            projects p ON c.project_id = p.id
        WHERE 
            c.user_id = userId;

        -- Update the average_score in the users table
        UPDATE users
        SET average_score = COALESCE(weightedAverage, 0)  -- Use 0 if there are no scores
        WHERE id = userId;
    END LOOP;

    -- Close the cursor
    CLOSE user_cursor;
END //

DELIMITER ;
