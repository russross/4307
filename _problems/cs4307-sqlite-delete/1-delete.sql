--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from within the sqlite3 shell using ".schema instructor"
--

--
-- write a SQL query to delete all students who have ever failed a class or
-- who have never taken a class.
--
-- note that the the schema for "takes" has cascading deletes, so this will
-- also delete all records of the affected students taking classes.
--
-- this should be a single DELETE query and there should be no output.
--
-- write your query here
--
DELETE FROM student
WHERE id IN
    (SELECT student.id
    FROM student
    LEFT OUTER JOIN takes ON student.id = takes.id
    WHERE grade IS NULL OR grade LIKE 'F%');
