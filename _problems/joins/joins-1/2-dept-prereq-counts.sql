--
-- write a query to list the departments that have courses
-- with prereqs and how many such courses each department has.
-- sort them from more prereqs to fewer.
--
SELECT dept_name, COUNT(1) AS prereqs
FROM course
JOIN prereq ON course.course_id = prereq.course_id
GROUP BY dept_name
ORDER BY prereqs DESC;
