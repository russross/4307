--
-- Find faculty teaching classes for other departments.
--
-- Note: a faculty member is part of a department, and
-- a course belongs to a department, so find sections where
-- these differ.
--

SELECT faculty.department AS faculty_department, faculty, courses.department AS course_department, section
FROM faculty
NATURAL JOIN faculty_sections
NATURAL JOIN sections
JOIN courses USING (course)
WHERE faculty_department <> course_department
ORDER BY faculty_department, faculty, course_department, section;
