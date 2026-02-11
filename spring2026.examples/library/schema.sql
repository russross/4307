
CREATE TABLE books (
    isbn            TEXT PRIMARY KEY,
    title           TEXT NOT NULL,
    pub_date        TEXT
);

CREATE TABLE authors (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    birth_date      TEXT
);

CREATE TABLE book_authors (
    isbn            TEXT NOT NULL,
    author_id       INTEGER NOT NULL,

    PRIMARY KEY (isbn, author_id),
    FOREIGN KEY (isbn) REFERENCES books (isbn),
    FOREIGN KEY (author_id) REFERENCES authors (id)
);

CREATE TABLE copies (
    isbn            TEXT NOT NULL,
    copy_num        INTEGER NOT NULL,

    PRIMARY KEY (isbn, copy_num),
    FOREIGN KEY (isbn) REFERENCES books (isbn)
);

CREATE TABLE patrons (
    card_number     INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    address         TEXT NOT NULL,
    fine_balance    REAL
);

CREATE TABLE lendings (
    card_number     INTEGER NOT NULL,
    isbn            TEXT NOT NULL,
    copy_num        INTEGER NOT NULL,
    due_date        TEXT NOT NULL,

    PRIMARY KEY (card_number, isbn, copy_num),
    FOREIGN KEY (card_number) REFERENCES patrons (card_number),
    FOREIGN KEY (isbn, copy_num) REFERENCES copies (isbn, copy_num)
);
