--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from within the sqlite3 shell using ".schema instructor"
--

--
-- write a SQL query to count the total number of students
-- in class during each time slot
-- sort the results by year, semester, and time slot ID
--
SELECT semester, year, time_slot_id, COUNT(1) AS total_students
FROM student
JOIN takes ON student.id = takes.id
JOIN section USING (course_id, sec_id, semester, year)
GROUP BY semester, year, time_slot_id
ORDER BY year, semester, time_slot_id;

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
