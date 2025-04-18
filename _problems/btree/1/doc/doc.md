B+-tree iterator
----------------

In the file `step.py` write the following function:

    def step_table(db: Database, root: int, key: int) -> Iterator[list[Any]]:

It accepts an open database (defined in `btree.py`), the page number
of the root of a table, and a key (rowid) where it should start
scanning. `step_table` should navigate the B+-tree until it finds
the given key (or the next higher key if the key is not present) and
then it should start yielding every row in order from that point
to the end of the table.

The function should also call the three counter functions (described
in the function comments) every time certain actions are performed.
Note that `inc_table_scans` should only be called once when
`step_table` is called by the client. You may wish to implement a
helper function for the recursive calls so that the counter is not
incremented too many times.

This process is a recursive search of the table tree structure. Here
are a few helpful notes:

*   The database object has a `load_page` method that will load any
    database page, update the appropriate counters, and decode the
    contents of the page, giving you back a Page objects (defined in
    `btree.py`.

*   It is an error if you are given the page number of anything
    other than a `TABLE_LEAF` or `TABLE_INTERIOR` page (these
    definitions are in `btree.py`. Failing an assert is a simple way
    to check for this:

        assert(page.page_type in (TABLE_LEAF, TABLE_INTERIOR))

*   When examining a page, always scan its cells from beginning to
    end. A binary search might be more efficient, but to match the
    expected counter values for the tests you must perform a linear
    scan of the keys in the page.

*   A cell of a B+-tree always contains a `rowid` field, and this is
    the key you should be comparing against.

*   The search should never yield a cell with rowid less than the
    requested key (this only applies to leaf pages), and you should
    not follow left links for such cells (this only applies to
    interior pages). The iterator essentially contains two phases:

    1.  Perform a stabbing query to find the first row with a
        qualifying rowid.

    2.  Scan the table from that point until the end of the table,
        yielding every row along the way.

    Note that a client that wishes to stop the scan early can just
    stop calling the iterator, so your code always continues to the
    end of the table once it finds a qualifying key.

*   To yield a value (like returning a value, but the code resumes
    running after a yield, whereas a return ends the function), use
    the `yield` keyword:

        yield [cell.rowid] + cell.fields

*   When an iterator function is called, it returns an iterator
    object that the client can then use to control the progress of
    the search (typically in a for loop). If you wish to make a
    call to another function that also acts as an interator, or if
    you need to make a recursive call to an iterator function, you
    need to use special syntax so that Python continues the
    iteration in the called function (and does not just return a new
    iterator objects). If the function to be called is called
    `search` you would call it like:

        yield from search(arguments)

*   Remember that interior pages have a right link, so you must
    follow it after processing all cells and left links.
