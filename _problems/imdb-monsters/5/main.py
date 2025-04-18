from btree import Database, report
from query import getCatalog, findPeople2

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    findPeople2(db, catalog, 'Monsters, Inc.')
    report()

main()
