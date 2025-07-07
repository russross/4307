--
-- repeat the previous query, but only show entries for students
-- that have taken multiple classes from the same instructor
--
SELECT student.name AS student_name, instructor.name AS instructor_name, COUNT(1) AS course_count
FROM student
JOIN takes ON student.id = takes.id
JOIN section USING (course_id, sec_id, semester, year)
JOIN teaches USING (course_id, sec_id, semester, year)
JOIN instructor ON teaches.id = instructor.id
GROUP BY student.id, student.name, instructor.id, instructor.name
HAVING course_count > 1
ORDER BY student_name, instructor_name;
