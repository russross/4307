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
