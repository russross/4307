-- download and build the full set using python package
--
-- imdb-sqlite
--

-- turn off slow stuff including crash safety
-- but enforce foreign keys
PRAGMA foreign_keys = ON;
PRAGMA temp_store = memory;
PRAGMA mmap_size = 8000000000;
PRAGMA journal_mode = OFF;
PRAGMA synchronous = OFF;

-- rename the raw tables
ALTER TABLE titles RENAME TO raw_titles;
ALTER TABLE people RENAME TO raw_people;
ALTER TABLE crew RENAME TO raw_crew;

-- create the new versions with revised types and added constraints

CREATE TABLE people (
    person_id       INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    born            INTEGER,
    died            INTEGER
);
CREATE TABLE titles (
    title_id        INTEGER PRIMARY KEY,
    type            TEXT NOT NULL,
    primary_title   TEXT NOT NULL,
    original_title  TEXT NOT NULL,
    is_adult        BOOLEAN NOT NULL,
    premiered       INTEGER,
    ended           INTEGER,
    runtime_minutes INTEGER,
    genres          TEXT,
    weighted_rating REAL NOW NULL
);
CREATE TABLE crew (
    title_id        INTEGER NOT NULL,
    person_id       INTEGER NOT NULL,
    category        TEXT NOT NULL,
    job             TEXT,
    characters      TEXT,

    FOREIGN KEY (title_id) REFERENCES titles(title_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (person_id) REFERENCES people(person_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- copy the top 2500 movie titles by weighted rating
-- changing ID to be an INTEGER
WITH
    av (average_rating) AS (
        SELECT SUM(rating * votes) / SUM(votes)
        FROM ratings
        NATURAL JOIN raw_titles
        WHERE type = 'movie' 
    ),
    mn (min_rating) AS (
        SELECT 25000.0
    ),
    toptitles (title_id, primary_title, weighted_rating) AS (
        SELECT
            title_id,
            primary_title,
            (votes / (votes + min_rating)) * rating + (min_rating / (votes + min_rating)) * average_rating as weighted_rating
        FROM ratings, av, mn
        NATURAL JOIN raw_titles
        WHERE type = 'movie'
        ORDER BY weighted_rating DESC
        LIMIT 2500
    )

INSERT INTO titles (
    title_id,
    type,
    primary_title,
    original_title,
    is_adult,
    premiered,
    ended,
    runtime_minutes,
    genres,
    weighted_rating
)
SELECT 
    CAST (SUBSTR(title_id, 3) AS INTEGER),
    type,
    primary_title,
    original_title,
    is_adult,
    premiered,
    ended,
    runtime_minutes,
    genres,
    weighted_rating
FROM toptitles 
NATURAL JOIN raw_titles;

-- copy anyone that is an (actor, actress, self, director, writer) on a title in the list
INSERT INTO people (
    person_id,
    name,
    born,
    died
)
SELECT DISTINCT
    CAST (SUBSTR(person_id, 3) AS INTEGER),
    name,
    born,
    died
FROM raw_people
NATURAL JOIN raw_crew
WHERE CAST (SUBSTR(title_id, 3) AS INTEGER) IN (SELECT title_id FROM titles)
AND category IN ('actor', 'actress', 'self', 'director', 'writer');

-- copy linking crew entries
INSERT INTO crew (
    title_id,
    person_id,
    category,
    job,
    characters
)
SELECT
    CAST (SUBSTR(title_id, 3) AS INTEGER),
    CAST (SUBSTR(person_id, 3) AS INTEGER),
    category,
    job,
    characters
FROM raw_crew
WHERE CAST (SUBSTR(title_id, 3) AS INTEGER) IN (SELECT title_id FROM titles)
AND   CAST (SUBSTR(person_id, 3) AS INTEGER) IN (SELECT person_id FROM people)
AND   category IN ('actor', 'actress', 'self', 'director', 'writer');

-- drop everything else
DROP TABLE akas;
DROP TABLE episodes;
DROP TABLE ratings;
DROP TABLE raw_crew;
DROP TABLE raw_titles;
DROP TABLE raw_people;

VACUUM;
ANALYZE;
