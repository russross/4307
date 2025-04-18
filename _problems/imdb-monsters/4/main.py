from btree import Database, report
from query import getCatalog, findPeople1

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    findPeople1(db, catalog, 'Monsters, Inc.')
    report()

main()
