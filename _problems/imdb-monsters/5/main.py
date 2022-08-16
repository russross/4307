from btree import Database, print_page, report
from step import step_table, step_index
from query import getCatalog, findPeople2
from typing import Any, Optional, Tuple, Dict
import sys

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    findPeople2(db, catalog, 'Monsters, Inc.')
    report()

main()
