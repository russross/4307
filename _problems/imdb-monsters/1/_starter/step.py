from btree import *
from typing import Tuple, Any, Iterator

# Copy your implementation of the btree iterator code here
# Note: the function types given here have been updated to be a little more precice.
# Use these types but your existing code.

def step_table(db: Database, root: int, key: int) -> Iterator[Tuple[int, Tuple[Any, ...]]]:
    pass

def step_index(db: Database, root: int, key: Tuple[Any, ...]) -> Iterator[Tuple[Tuple[Any, ...], Tuple[Any, ...]]]:
    pass
