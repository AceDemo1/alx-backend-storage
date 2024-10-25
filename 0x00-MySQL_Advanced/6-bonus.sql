-- create procedure

DELIMITER /
CREATE PROCEDURE AddBonus(user_id inT, project_name VARCHAR(255), score INT)
BEGIN
	DECLARE p_name VARCHAR(255);
	SELECT name INTO p_name 
	FROM projects
	WHERE name = project_name;

	IF p_name IS NULL THEN
		INSERT INTO projects (name)
		VALUES (project_name);
		SET p_name = project_name;
	END IF;

	INSERT INTO corrections (user_id, project_id, score)
	VALUES (user_id, (SELECT id FROM projects WHERE name=p_name), score);
END /
DELIMITER ;
