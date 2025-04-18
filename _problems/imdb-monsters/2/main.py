from btree import Database, report
from query import getCatalog, scanForTitle

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    scanForTitle(db, catalog, 'Monsters, Inc.')
    report()

main()
