--
-- write a SQL query to list the total salary budget for each
-- department, starting with the most expensive department
-- note: this only needs to involve the instructor table
--
SELECT dept_name, SUM(salary) AS total_budget
FROM instructor
GROUP BY dept_name
ORDER BY total_budget DESC;
