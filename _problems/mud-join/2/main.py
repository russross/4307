from btree import Database, print_page, report
from step import step_table, step_index
from query import getCatalog, incoming_rooms_index
from typing import Any, Optional, Tuple, Dict
import sys

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    incoming_rooms_index(db, catalog)
    report()

main()
