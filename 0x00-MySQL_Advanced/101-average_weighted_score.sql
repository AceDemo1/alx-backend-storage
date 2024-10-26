-- create
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE userId INT;
    DECLARE total_users INT;
    DECLARE current_user INT DEFAULT 1;
    
    -- Get the total number of users
    SELECT COUNT(*) INTO total_users FROM users;
    
    -- Process each user
    WHILE current_user <= total_users DO
        -- Get the user ID for the current iteration
        SELECT id INTO userId 
        FROM users 
        ORDER BY id 
        LIMIT current_user - 1, 1;
        
        -- Update the user's average score
        UPDATE users 
        SET average_score = (
            SELECT COALESCE(SUM(c.score * p.weight) / SUM(p.weight), 0)
            FROM corrections c
            JOIN projects p ON c.project_id = p.id
            WHERE c.user_id = userId
        )
        WHERE id = userId;
        
        -- Move to next user
        SET current_user = current_user + 1;
    END WHILE;
END //

DELIMITER ;
