from btree import Database, report
from query import getCatalog

FILENAME = 'database.db'

def main() -> None:
    db = Database(FILENAME)
    catalog = getCatalog(db)
    for name in ['people', 'titles', 'crew', 'titles_by_primary_title', 'crew_by_title_and_person']:
        print(name, 'is rooted at page', catalog[name])
    report()

main()
