from btree import Database, report
from query import getCatalog, baconNumbers

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    baconNumbers(db, catalog, 'Kevin Bacon')
    report()

main()
