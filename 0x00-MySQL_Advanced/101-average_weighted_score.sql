-- create
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    UPDATE users u
    LEFT JOIN (
        SELECT c.user_id, 
               SUM(c.score * p.weight) / SUM(p.weight) as weighted_avg
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        GROUP BY c.user_id
    ) as weighted_scores ON u.id = weighted_scores.user_id
    SET u.average_score = COALESCE(weighted_scores.weighted_avg, 0);
END //

DELIMITER ;
