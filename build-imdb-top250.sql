-- download and build the full set using python package
--
-- imdb-sqlite
--

-- delete all titles except the top 2500 movies
WITH
  av(average_rating) AS (
    SELECT SUM(rating * votes) / SUM(votes)
      FROM ratings
      JOIN titles
      ON titles.title_id == ratings.title_id AND titles.type == "movie" 
  ),
  mn(min_rating) AS (SELECT 25000.0),
  toptitles(title_id, primary_title, weighted_rating) AS

(SELECT
  titles.title_id,
  primary_title,
  (votes / (votes + min_rating)) * rating + (min_rating / (votes + min_rating)) * average_rating as weighed_rating
  FROM ratings, av, mn
  JOIN titles
  ON titles.title_id == ratings.title_id and titles.type == "movie"
  ORDER BY weighed_rating DESC
  LIMIT 2500)

delete from titles where title_id not in (select title_id from toptitles);


-- delete anyone not an (actor, acress, self, director, writer) on a movie
with actors(person_id) AS (
select person_id
from people natural join crew natural join titles
where crew.category in ('actor', 'actress', 'self', 'director', 'writer')
)

delete from people where person_id not in (select person_id from actors);

-- cascade deletes
delete from crew where title_id not in (select title_id from titles);
delete from crew where person_id not in (select person_id from people);
delete from ratings where title_id not in (select title_id from titles);
drop table episodes;
drop table akas;

-- dump to sql file, update schema to add foreign key and not null constraints, rebuild db

CREATE TABLE people (
  person_id VARCHAR PRIMARY KEY,
  name VARCHAR NOT NULL,
  born INTEGER,
  died INTEGER
);
CREATE TABLE titles (
  title_id VARCHAR PRIMARY KEY,
  type VARCHAR NOT NULL,
  primary_title VARCHAR NOT NULL,
  original_title VARCHAR NOT NULL,
  is_adult INTEGER NOT NULL,
  premiered INTEGER,
  ended INTEGER,
  runtime_minutes INTEGER,
  genres VARCHAR
);
CREATE TABLE akas (
  title_id VARCHAR NOT NULL,
  title VARCHAR NOT NULL,
  region VARCHAR,
  language VARCHAR,
  types VARCHAR,
  attributes VARCHAR,
  is_original_title INTEGER
);
CREATE TABLE crew (
  title_id VARCHAR NOT NULL,
  person_id VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  job VARCHAR,
  characters VARCHAR,
  FOREIGN KEY (title_id) REFERENCES titles(title_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (person_id) REFERENCES people(person_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE ratings (
  title_id VARCHAR PRIMARY KEY,
  rating INTEGER,
  votes INTEGER,
  FOREIGN KEY (title_id) REFERENCES titles(title_id) ON DELETE CASCADE ON UPDATE CASCADE
);
