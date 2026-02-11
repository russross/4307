SELECT patrons.name AS patron_name, author.name AS author_name
FROM patrons
NATURAL JOIN lendings
NATURAL JOIN copies
NATURAL JOIN books
NATURAL JOIN book_authors
JOIN authors ON authors.id = author_id;
