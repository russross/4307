from btree import Database, report
from query import getCatalog, findPeopleIndex

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    findPeopleIndex(db, catalog, 'Monsters, Inc.')
    report()

main()
