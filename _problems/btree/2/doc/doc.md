B-tree iterator
---------------

In the file `step.py` write the following function:

    def step_index(db: Database, root: int, key: Tuple[Any, ...]) -> Iterator[Tuple[Tuple[Any, ...], Tuple[Any, ...]]]:

This function is similar to `step_table`, but it navigates index
B-trees instead of table B+-trees.

Here are a few important differences:

*   The key is a tuple instead of an integer. The rowid field of a
    Page is empty, and instead a row key is just a prefix of the row
    tuple. You can use a slice to extract a portion of a tuple. For
    example, to get a tuple containing just the first three fields
    of another tuple, use:

        prefix = original[:3]

    The length of the key parameter tells you how many fields to
    consider when looking at each row.

*   It is an error to call `step_index` on a page that is not an
    `INDEX_LEAF` or an `INDEX_INTERIOR`.

*   Interior pages contain complete rows, so you must yield values
    from interior pages as well as leaf pages.

*   Duplicate keys are normal in indexes (whereas rowid values are
    always unique). This implies that when you find a matching key
    in an interior node, you must still recusively navigate down the
    left child link before yielding the value from the interior
    node. You can find a matching key, but you cannot know if it is
    the *first* matching key without actually searching left.

*   Python lets you compare two tuples using normal relational
    operators:

        >    <    ==    !=    <=    >=

    It always compares the first element of each tuple first, and
    proceeds to later fields only if necessary.

*   SQL NULL values are represented using the Python None value. We
    will ignore the special SQL rules concerning NULL values and
    just avoid comparisons between None and other values (such
    comparisons normally trigger a Python exception).

This function should be very similar to `step_table`.
