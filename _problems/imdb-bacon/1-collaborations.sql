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
--   +----------------+-------------------+-------------------+
--   | collaborations |       name1       |       name2       |
--   +----------------+-------------------+-------------------+
--   | 13             | Ethan Coen        | Joel Coen         |
--   | 13             | Joel Coen         | Ethan Coen        |
--   | 11             | Akira Kurosawa    | Toshirô Mifune    |
--   | 11             | Ertem Egilmez     | Sadik Sendil      |
--   | 11             | Sadik Sendil      | Ertem Egilmez     |
--   | 11             | Toshirô Mifune    | Akira Kurosawa    |
--   | 9              | Akira Kurosawa    | Hideo Oguni       |
--   | 9              | Ertem Egilmez     | Kemal Sunal       |
--   | 9              | Hideo Oguni       | Akira Kurosawa    |
--   | 9              | Kemal Sunal       | Ertem Egilmez     |
--   | 9              | Sener Sen         | Yavuz Turgul      |
--   | 9              | Yavuz Turgul      | Sener Sen         |
--   | 8              | Akira Kurosawa    | Ryûzô Kikushima   |
--   | 8              | Daniel Radcliffe  | J.K. Rowling      |
--   | 8              | Daniel Radcliffe  | Rupert Grint      |
--   | 8              | Ertem Egilmez     | Sener Sen         |
--   | 8              | Fran Walsh        | Peter Jackson     |
--   | 8              | J.K. Rowling      | Daniel Radcliffe  |
--   ... (and so forth)
--
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
