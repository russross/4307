--
-- write a SQL query to count the number of times each student
-- has taken a course from each instructor
-- sort the results by student first, instructor second
--
SELECT student.name AS student_name, instructor.name AS instructor_name, COUNT(1) AS course_count
FROM student
JOIN takes ON student.id = takes.id
JOIN section USING (course_id, sec_id, semester, year)
JOIN teaches USING (course_id, sec_id, semester, year)
JOIN instructor ON teaches.id = instructor.id
GROUP BY student.id, student.name, instructor.id, instructor.name
ORDER BY student_name, instructor_name;
