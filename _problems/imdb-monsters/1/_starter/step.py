from btree import (
    Database,
    INDEX_INTERIOR,
    INDEX_LEAF,
    TABLE_INTERIOR,
    TABLE_LEAF,
    inc_index_scans,
    inc_rows_returned,
    inc_rows_scanned,
    inc_table_scans,
)
from typing import Any, Iterator

# Copy your implementation of the btree iterator code here

def step_table(db: Database, root: int, key: int) -> Iterator[list[Any]]:
    yield []

def step_index(db: Database, root: int, key: list[Any]) -> Iterator[list[Any]]:
    yield []
