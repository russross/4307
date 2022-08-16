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
    genres          TEXT
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
CREATE TABLE ratings (
    title_id        INTEGER PRIMARY KEY,
    rating          INTEGER,
    votes           INTEGER,
    FOREIGN KEY (title_id) REFERENCES titles(title_id) ON DELETE CASCADE ON UPDATE CASCADE
);
