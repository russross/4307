Write queries as prompted each `*.sql` file.

We will demonstrate a few of these in class as well.

Each `*.sql` file contains a comment with a description of the query to write.
Write each SELECT query right below the comment to return the requested data.

All queries in this problem can be satisfied using only the "states" table in
the database.

The database schema is given in the file .a-schema.sql, or you can ask the
database to report the schema to you. To load an interactive SQL shell, use:

    sqlite3 database.db

or you can use:

    make shell

which rebuilds the database each time (helpful if you run descructive queries).

Within the shell you can see the schema for the "states" table by typing:

    .schema states

I recommend trying each query out interactively first, then copying it into the
file. Some details are omitted from the instructions and you are expected to
figure them out by looking at the expected output.

Note: the expected output of each of the queries is given in the corresponding
`*.transcript` in the `outputs/` directory.

For example, in the first query the expected output has a heading of
`states_count`, but you will only know that by looking at the expected output.
To modify the default heading, you need to rename the result relation using `AS
states_count` or similar.

In other queries, the exact set of attributes that you need to return, the order
in which they should be presented, etc., may be omitted from the instructions,
and you should plan to look at the expected output to fill in the details.
