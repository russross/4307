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
