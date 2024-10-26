-- create procedure

DELIMITER $
CREATE PROCEDURE ComputeAverageWeightedScoreForUser()
BEGIN
        DECLARE NUM FLOAT;
        DECLARE DEMU FLOAT;
	DECLARE user_id INT DEFAULT 1;
	DECLARE total_users INT DEFAULT 0;

	SELECT COUNT(*) INTO total_users FROM users;
	WHILE user_id <= total_users DO

		SELECT SUM(score * weight) INTO NUM FROM corrections
		JOIN projects ON corrections.project_id=projects.id
		WHERE corrections.user_id=user_id;

		SELECT SUM(weight) INTO DEMU FROM projects
		JOIN corrections ON projects.id=corrections.project_id
		WHERE corrections.user_id=user_id;
	
		IF DEMU <= 0 THEN
			UPDATE users SET average_score = 0 WHERE id = user_id;
		ELSE
			UPDATE users SET average_score = NUM / DEMU WHERE id = user_id;
		END IF; 
		SET user_id = user_id + 1;
	END WHILE;
END $
DELIMITER ;
