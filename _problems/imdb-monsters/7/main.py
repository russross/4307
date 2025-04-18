from btree import Database, report
from query import getCatalog, findPeopleCoveringIndex

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    findPeopleCoveringIndex(db, catalog, 'Monsters, Inc.')
    report()

main()
