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
	
	UPDATE users
	IF DEMU <= 0 THEN
		SET average_score = 0
	ELSE
		SET average_score = NUM / DEMU;
	END IF;
	WHERE id = user_id;
END $
DELIMITER ;
