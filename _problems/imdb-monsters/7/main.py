from btree import Database, print_page, report
from step import step_table, step_index
from query import getCatalog, findPeopleCoveringIndex
from typing import Any, Optional, Tuple, Dict
import sys

FILENAME = 'database.db'

db = Database(FILENAME)
catalog = getCatalog(db)
