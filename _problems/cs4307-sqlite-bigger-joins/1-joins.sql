--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from within the sqlite3 shell using ".schema instructor"
--

--
-- write a SQL query to count the total number of students
-- in class during each time slot
-- sort the results by year, semester, and time slot ID
--
-- the output should look like:
--
--   semester    year        time_slot_id  total_students
--   ----------  ----------  ------------  --------------
--   Fall        2017        A             3
--   Fall        2017        H             6
--   Spring      2017        A             2
--   Spring      2017        C             1
--   Summer      2017        B             1
--   Spring      2018        B             2
--   Spring      2018        C             2
--   Spring      2018        D             3
--   Spring      2018        F             1
--   Summer      2018        A             1
--
-- write your query on the next line
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
-- the output should look like:
--
--   student_name  instructor_name  course_count
--   ------------  ---------------  ------------
--   Aoi           Kim              1           
--   Bourikas      Srinivasan       2           
--   Brandt        El Said          1           
--   Brown         Brandt           1           
--   Brown         Srinivasan       1           
--   Chavez        Wu               1           
--   Levy          Katz             2           
--   Levy          Srinivasan       1           
--   Peltier       Einstein         1           
--   Sanchez       Mozart           1           
--   Shankar       Brandt           1           
--   Shankar       Srinivasan       3           
--   Tanaka        Crick            2           
--   Williams      Brandt           1           
--   Williams      Srinivasan       1           
--   Zhang         Srinivasan       2
--
-- write your query on the next line
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
-- the output should look like:
--
--   student_name  instructor_name  course_count
--   ------------  ---------------  ------------
--   Bourikas      Srinivasan       2           
--   Levy          Katz             2           
--   Shankar       Srinivasan       3           
--   Tanaka        Crick            2           
--   Zhang         Srinivasan       2
--
-- write your query on the next line
SELECT student.name AS student_name, instructor.name AS instructor_name, COUNT(1) AS course_count
FROM student
JOIN takes ON student.id = takes.id
JOIN section USING (course_id, sec_id, semester, year)
JOIN teaches USING (course_id, sec_id, semester, year)
JOIN instructor ON teaches.id = instructor.id
GROUP BY student.id, student.name, instructor.id, instructor.name
HAVING course_count > 1
ORDER BY student_name, instructor_name;
