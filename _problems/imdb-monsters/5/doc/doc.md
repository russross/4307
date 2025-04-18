Finding people associated with a movie with no indices, plan 2
--------------------------------------------------------------

Implement a function in `query.py` with the following name and type:

    def findPeople2(db: Database, catalog: dict[str, int], title: str) -> None:

This one performs the complete join query without using any indices:

    SELECT people.*
    FROM people
    NATURAL JOIN crew
    NATURAL JOIN titles
    WHERE primary_title = 'Monsters, Inc.';

but uses a different execution strategy (the one SQLite suggests):

*   Scan the entire crew table.

*   For each crew entry, use the title ID to perform a stabbing
    query into the title table and then check if the title is a
    match.

*   If the title is a match, use the person ID from the crew entry
    to perform a stabbing query into the people table and print the
    matching row.
