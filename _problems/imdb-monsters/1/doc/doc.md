Reading the schema catalog
--------------------------

This problem has a series of steps where you will implement queries
using your btree iterator over sqlite data files. All of these
center around this query:

    SELECT people.*
    FROM people
    NATURAL JOIN crew
    NATURAL JOIN titles
    WHERE primary_title = 'Monsters, Inc.';

In this first step, you will read the schema catalog, which will let
you find the root page of any table or index given its name. The
catalog also contains the original CREATE statements, but we will
ignore them for the purposes of this problem.

First, copy your btree iterator code into `step.py`. You should not
have to make any changes to your iterator code.

Next, implement a function in `query.py` to read the schema catalog
using your `step_table` function. You should scan the entire table
(which is rooted at page 1) and build a dictionary to return. The
dictionary key should be the name of the table or index (the catalog
contains both) and the value should be the root page of the
table/index.

A few details:

*   To scan the entire table, call `step_table` with a rowid of 0
    and iterate over all entries that it returns.

*   The title of each table or index is the cell at index 2 in the
    catalog entry.

*   The root of the table or index is the cell at index 4 in the
    catalog entry.

Your function should have the following name and type:

    def getCatalog(db: Database) -> dict[str, int]:

i.e., it should return an ordinary Python dictionary where the keys
are strings (the table/index name) and the values are ints (the root
page number of the table/index).
