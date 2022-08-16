Scan for title
--------------

In this step you will add a new function to `query.py` with the
following name and type:

    def scanForTitle(db: Database, catalog: Dict[str, int], title: str) -> None:

It is given the schema catalog that you generated in the previous
step and the title of a movie. It should step through the entire
titles table and find any movies that match the given title. Note
that the database does not have any constraint that guarantees that
a title is unique, so you should always assume there could be
multiple matches and write your code to handle that possibility.

When you find the matching title, print out the entire row using
something like:

    print(f'rowid: {rowid}, row: {row}')

where `rowid` and `row` are the values returned by the btree
iterator.
