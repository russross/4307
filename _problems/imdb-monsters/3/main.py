from btree import Database, report
from query import getCatalog, stabForTitle

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    stabForTitle(db, catalog, 'Monsters, Inc.')
    report()

main()
