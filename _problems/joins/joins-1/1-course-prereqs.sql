--
-- write a query to list courses with prereqs. most of the information
-- should come from the course, with just the prereq_id added for
-- the course's prereq. sort by course_id.
--
-- this will require joining the tables course and prereq.
-- use the JOIN syntax, not a comma-separated list of tables.
--
SELECT course.course_id, title, dept_name, credits, prereq_id
FROM course
JOIN prereq ON course.course_id = prereq.course_id
ORDER BY course.course_id;
