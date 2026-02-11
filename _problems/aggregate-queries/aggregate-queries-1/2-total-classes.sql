--
-- write a query to list the total number of classes taught in each
-- semester. The list should be sorted by year, with semester used as
-- a tie breaker
--
SELECT semester, year, COUNT(1) AS total_classes
FROM teaches
GROUP BY year, semester
ORDER BY year, semester;
