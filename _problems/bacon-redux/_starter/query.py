from btree import Database
from step import step_table, step_index

def getCatalog(db: Database) -> dict[str, int]:
    catalog = {}
    for row in step_table(db, 1, 0):
        catalog[row[2]] = row[4]
    return catalog

def baconNumbers(db: Database, catalog: dict[str, int], name: str) -> None:
    people_by_name = catalog['people_by_name']
    crew_by_title_and_person_root = catalog['crew_by_title_and_person']
    crew_by_person_and_title_root = catalog['crew_by_person_and_title']

    # implement the query here

    # print the results
    print('+-----------+-----------------------------------+---+')
    print('| person_id |               name                | n |')
    print('+-----------+-----------------------------------+---+')
    for (person_id, name, n) in final_rows:
        print(f'| {person_id:<9} | {name:33} | {n} |')
    print('+-----------+-----------------------------------+---+')
