--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from within the sqlite3 shell using .schema
--

--
-- write a SQL query to find the top collaborators in the database,
-- i.e., the actors, directores, and writers who have the most titles in common
--
-- the result set should include every pair of names and the number
-- of titles in common for people who worked on titles together
--
-- order the results by most collaborations to fewest, then by
-- the name of the first person listed and finally by the second person
-- note that each pair of actors will appear twice in the list
--
-- limit your output to the first 50 rows
--
-- the output should look like:
--
--   collaborations  name1       name2     
--   --------------  ----------  ----------
--   13              Ethan Coen  Joel Coen 
--   13              Joel Coen   Ethan Coen
--   11              Akira Kuro  Toshirô Mi
--   11              Ertem Egil  Sadik Send
--   11              Sadik Send  Ertem Egil
--   11              Toshirô Mi  Akira Kuro
--   9               Akira Kuro  Hideo Ogun
--   9               Ertem Egil  Kemal Suna
--   9               Hideo Ogun  Akira Kuro
--   9               Kemal Suna  Ertem Egil
--   9               Sener Sen   Yavuz Turg
--   9               Yavuz Turg  Sener Sen 
--   8               Akira Kuro  Ryûzô Kiku
--   8               Daniel Rad  J.K. Rowli
--   8               Daniel Rad  Rupert Gri
--   8               Ertem Egil  Sener Sen 
--   8               Fran Walsh  Peter Jack
--   8               J.K. Rowli  Daniel Rad
--   ... (and so forth)
--
-- write your query on the next line
WITH together(name1, id1, name2, id2, title_id) AS
(
    SELECT DISTINCT
        people1.name as name1,
        people1.person_id as id1, 
        people2.name as name2,
        people2.person_id as id2,
        crew1.title_id
    FROM people AS people1
    JOIN crew AS crew1 ON people1.person_id = crew1.person_id
    JOIN crew AS crew2 ON crew1.title_id = crew2.title_id
    JOIN people AS people2 ON crew2.person_id = people2.person_id
    WHERE people1.person_id <> people2.person_id
)

SELECT COUNT(1) AS collaborations, name1, name2
FROM together
GROUP BY name1, id1, name2, id2
ORDER BY collaborations DESC, name1, name2
LIMIT 50;
