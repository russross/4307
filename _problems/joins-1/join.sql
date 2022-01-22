--
-- write a query to list courses with prereqs. most of the information
-- should come from the course, with just the prereq_id added for
-- the course's prereq. sort by course_id.
--
-- this will require joining the tables course and prereq.
-- use the JOIN syntax, not a comma-separated list of tables.
--
SELECT course.course_id, title, dept_name, credits, prereq_id
FROM course JOIN prereq ON course.course_id = prereq.course_id
ORDER BY course.course_id;

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

--
-- write a query with output similar to the previous one, but include the
-- title of the prereq course as well. this will require joining
-- on courses two times--once to get the info about the main course, and
-- a second time to get the title of the prereq.
--
SELECT course.course_id, course.title, course.dept_name, course.credits, prereq_id, prereq_course.title AS prereq_title
FROM course
JOIN prereq ON course.course_id = prereq.course_id
JOIN course AS prereq_course ON prereq.prereq_id = prereq_course.course_id
ORDER BY course.course_id;
