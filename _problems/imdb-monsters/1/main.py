from btree import Database, print_page, report
from step import step_table, step_index
from query import getCatalog
from typing import Any, Optional, Tuple, Dict
import sys

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    for name in ['people', 'titles', 'crew', 'titles_by_primary_title', 'crew_by_title_and_person']:
        print(name, 'is rooted at page', catalog[name])
    report()

main()
