Finding people associated with a movie with no indices, plan 1
--------------------------------------------------------------

Implement a function in `query.py` with the following name and type:

    def findPeople1(db: Database, catalog: dict[str, int], title: str) -> None:

This one performs the complete join query without using any indices:

    SELECT people.*
    FROM people
    NATURAL JOIN crew
    NATURAL JOIN titles
    WHERE primary_title = 'Monsters, Inc.';

You should use the following execution strategy:

*   Scan the entire titles table to find entries that match the
    given title.

*   For each match, scan the entire crew table to find entries that
    reference the title.

*   For each matching crew entry, use the person ID to perform a
    stabbing query into the people table and print the row in the
    same format as before. Remember that queries on the primary key
    do not need to scan any rows past the hit since there is only
    ever one matching record.
