--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from within the sqlite3 shell using ".schema instructor"
--
-- write a SQL query to list the total salary budget for each
-- department, starting with the most expensive department
-- note: this only needs to involve the instructor table
--
SELECT dept_name, SUM(salary) AS total_budget
FROM instructor
GROUP BY dept_name
ORDER BY total_budget DESC;

--
-- write a query to list the total number of classes taught in each
-- semester. The list should be sorted by year, with semester used as
-- a tie breaker
--
SELECT semester, year, COUNT(1) AS total_classes
FROM teaches
GROUP BY year, semester
ORDER BY year, semester;
