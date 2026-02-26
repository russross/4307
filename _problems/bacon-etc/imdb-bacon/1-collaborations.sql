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
--   +----------------+--------------------+--------------------+
--   | collaborations |       name1        |       name2        |
--   +----------------+--------------------+--------------------+
--   | 12             | Adile Nasit        | Sener Sen          |
--   | 12             | Ethan Coen         | Joel Coen          |
--   | 12             | Joel Coen          | Ethan Coen         |
--   | 12             | Sener Sen          | Adile Nasit        |
--   | 11             | Adile Nasit        | Kemal Sunal        |
--   | 11             | Aysen Gruda        | Sener Sen          |
--   | 11             | Kemal Sunal        | Adile Nasit        |
--   | 11             | Sener Sen          | Aysen Gruda        |
--   | 10             | Akira Kurosawa     | Takashi Shimura    |
--   | 10             | Akira Kurosawa     | Toshirô Mifune     |
--   | 10             | Takashi Shimura    | Akira Kurosawa     |
--   | 10             | Toshirô Mifune     | Akira Kurosawa     |
--   | 9              | Adile Nasit        | Aysen Gruda        |
--   | 9              | Adile Nasit        | Ertem Egilmez      |
--   | 9              | Adile Nasit        | Sadik Sendil       |
--   | 9              | Akira Kurosawa     | Hideo Oguni        |
--   | 9              | Aysen Gruda        | Adile Nasit        |
--   | 9              | Ertem Egilmez      | Adile Nasit        |
--   | 9              | Hideo Oguni        | Akira Kurosawa     |
--   | 9              | Kemal Sunal        | Sener Sen          |
--   | 9              | Sadik Sendil       | Adile Nasit        |
--   | 9              | Sener Sen          | Kemal Sunal        |
--   | 9              | Takashi Shimura    | Toshirô Mifune     |
--   | 9              | Toshirô Mifune     | Takashi Shimura    |
--   | 8              | Adile Nasit        | Halit Akçatepe     |
--   | 8              | Akira Kurosawa     | Ryûzô Kikushima    |
--   | 8              | Daniel Radcliffe   | Emma Watson        |
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
