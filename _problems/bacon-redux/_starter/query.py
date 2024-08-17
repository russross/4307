from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional, Tuple, Dict

def getCatalog(db: Database) -> Dict[str, int]:
    catalog = {}
    for (rowid, row) in step_table(db, 1, 0):
        catalog[row[1]] = row[3]
    return catalog

def baconNumbers(db: Database, catalog: Dict[str, int], name: str) -> None:
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
