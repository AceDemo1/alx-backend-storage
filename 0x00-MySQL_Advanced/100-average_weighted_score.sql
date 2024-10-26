-- create procedure

DELIMITER $
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
        DECLARE NUM FLOAT;
        DECLARE DEMU FLOAT;

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
END $
DELIMITER ;
