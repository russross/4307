from btree import Database, print_page, report
from step import step_table, step_index
from query import getCatalog, baconNumbers
from typing import Any, Optional, Tuple, Dict
import sys

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    baconNumbers(db, catalog, 'Kevin Bacon')
    report()

main()
