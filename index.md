CS 4307: Database Systems
=========================

Spring 2021                     | Reading                       | Project
--------------------------------|-------------------------------|-------------------------------
Jan 11–15                       | 2: relational model           | sql 1
Jan 18–22 (*MLK Day*)           | 3: introduction to SQL        | sql 2
Jan 25–29                       | 4: intermediate SQL           | sql 3
Feb 1–5                         | 5: advanced SQL               | sql 4
Feb 8–12                        | 6: entity-relationship model  | sql 5
Feb 15–19 (*Presidents' Day*)   | 7: relational database design | sql 6
Feb 22–26                       | 8: complex data types         | sql 7
Mar 1–5                         | 13: data storage structures   |
Mar 8–12 (*Spring break*)       | —                             | —
Mar 15–19                       | 14: indexing                  | chidb: B-Trees
Mar 22–26                       | 15: query processing          |
Mar 29–Apr 2                    | 16: query optimization        | chidb: Database Machine
Apr 5–9                         | 17: transactions              |
Apr 12–16                       | 18: concurrency control       | chidb: Code Generation
Apr 19–23                       | 19: recovery system           |
Apr 26–30 (*Wednesday last day*)|                               | chidb: Query Optimization

All readings are from the textbook.

- - - - -

Resources
---------

*   [Syllabus](syllabus.php)
*   [Examples from class](spring2021.php)
*   [Stonebraker: One Size Fits None](https://www.youtube.com/watch?v=qyDPqbpbA60)

Projects
--------

*   [Reading a SQLite file](asst_read_sqlite.php)
      \[[plain](asst_read_sqlite.html)]
      \[[pdf](asst_read_sqlite.pdf)]

*   [BTree query starter code](sqlite_iterator.tar.gz)

    *   Build the IMDB dataset and call it test.db. You can use [this dump file](imdb-dump.sql).

    *   To find the root page of each table, use `SELECT * FROM sqlite_master;` to dump the schema.

    *   Implement the following query:

            SELECT people.name
            FROM people
            JOIN crew ON people.person_id = crew.person_id
            JOIN titles ON crew.title_id = titles.title_id
            WHERE titles.primary_title = 'Inception'

        Implement it using the following strategies:

        *   Scan the titles table to find the title_id of 'Inception', then
            scan the crew table and for each record with matching title_id 
            lookup the record in people and print the result.

        *   Scan the crew table, and for each record look up the
            corresponding title entry. If it's a match, look up the
            corresponding person entry and print it.

        *   Create an index:

                CREATE INDEX crew_title_id ON crew (title_id);

            Search the titles table to find the title_id, use the index
            to find matching crew entries, and for each one lookup the
            matching person record and print out info.
