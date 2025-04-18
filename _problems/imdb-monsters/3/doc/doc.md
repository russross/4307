Finding a title using an index
------------------------------

Write a new function in `query.py` with the following name and type:

    def stabForTitle(db: Database, catalog: dict[str, int], title: str) -> None:

This finds and prints the same information as the previous step, but
uses an index to find the title(s) without resorting to a full table
scan. The index was defined using:

    CREATE INDEX titles_by_primary_title ON titles (primary_title);

Your function should do the following:

*   Use the index iterator to scan for the title. You should
    continue scanning index rows until you find one that does not
    match the title (this is how you will know that you have found
    all entries that *do* match the title).

*   For each matching entry, create a new iterator to search the
    titles table, this time giving it the primary key (taken from
    the index entry) so it can jump directly to the row. Since the
    primary key is unique, there can only be one matching row so you
    can terminate the iterator after reading a single entry. I
    suggest using the built-in `next` function:

        title_row = next(iterator)

    which returns a single value from the iterator and does not
    require setting up a for loop.

*   Print the row the same as you did in the version that performed
    a full table scan.
