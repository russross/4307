from btree import *
from typing import Any, Iterator

# An iterator to step through the values in a table
# starting at root page, and starting with given key.
#
# The key is an integer rowid.
#
# Yields once for each row with rowid >= the key.
#
# Yields a list of the form:
#
#     [rowid, cell, fields, in, order]
#
# Calls counter functions to track work done:
#
#   * inc_table_scans() is called once each time step_table is called
#   * inc_rows_scanned() called each time a page cell is examined/compared against the key
#   * inc_rows_returned() called each time a row is yielded
def step_table(db: Database, root: int, key: int) -> Iterator[list[Any]]:
    inc_table_scans()

    def search(root: int) -> Iterator[list[Any]]:
        page = db.load_page(root)
        assert(page.page_type in (TABLE_LEAF, TABLE_INTERIOR))

        for (index, cell) in enumerate(page.cells):
            inc_rows_scanned()
            cell_key = cell.rowid
            assert(cell_key is not None)
            if cell_key >= key:
                if cell.left_child is not None:
                    yield from search(cell.left_child)
                if len(cell.fields) > 0:
                    inc_rows_returned()
                    yield [cell_key] + cell.fields
        if page.right_child is not None:
            yield from search(page.right_child)

    return search(root)

# An iterator to step through the values in an index
# starting at root page, and starting with given key.
#
# The key is a list.
#
# Yields once for each row with a key >= the given key
# where the key is the cell data prefix with the same size as the key.
#
# Yields a list of the form:
#
#     [cell, fields, in, order]
#
# Calls counter functions to track work done:
#
#   * inc_index_scans() is called once each time step_index is called
#   * inc_rows_scanned() called each time a page cell is examined/compared against the key
#   * inc_rows_returned() called each time a row is yielded
def step_index(db: Database, root: int, key: list[Any]) -> Iterator[list[Any]]:
    inc_index_scans()

    def search(root: int) -> Iterator[list[Any]]:
        page = db.load_page(root)
        assert(page.page_type in (INDEX_LEAF, INDEX_INTERIOR))

        for (index, cell) in enumerate(page.cells):
            inc_rows_scanned()
            cell_key = cell.fields[:len(key)]
            if cell_key >= key:
                if cell.left_child is not None:
                    yield from search(cell.left_child)
                inc_rows_returned()
                yield cell.fields
        if page.right_child is not None:
            yield from search(page.right_child)

    return search(root)
