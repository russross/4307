--
-- Write a query to find the total number of sections assigned
-- to each faculty member (including unscheduled sections).
--
-- Sort the results by the department the faculty member is in.
--

SELECT department, faculty, COUNT(1)
FROM faculty
NATURAL JOIN faculty_sections
GROUP BY department, faculty
ORDER BY department, faculty;

