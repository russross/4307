from btree import *
from typing import Tuple, Any, Iterator

def step_table(db: Database, root: int, key: int) -> Iterator[Tuple[int, Tuple[Any, ...]]]:
    # copy your implementation of step_table here

def step_index(db: Database, root: int, key: Tuple[Any, ...]) -> Iterator[Tuple[Any, ...]]:
    # copy your implementation of step_index here
