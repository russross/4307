from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional, Tuple, Dict

def getCatalog(db: Database) -> Dict[str, int]:
    catalog = {}
    for (rowid, row) in step_table(db, 1, 0):
        catalog[row[1]] = row[3]
    return catalog

def scanForTitle(db: Database, catalog: Dict[str, int], title: str) -> None:
    root = catalog['titles']
    for (rowid, row) in step_table(db, root, 0):
        if row[2] != title:
            continue
        print(f'rowid: {rowid}, row: {row}')

def stabForTitle(db: Database, catalog: Dict[str, int], title: str) -> None:
    index = catalog['titles_by_primary_title']
    root = catalog['titles']
    for row in step_index(db, index, (title,)):
        if row[0] != title:
            break
        (rowid, row) = next(step_table(db, root, row[1]))
        print(f'rowid: {rowid}, row: {row}')

def findPeople1(db: Database, catalog: Dict[str, int], title: str) -> None:
    # scan the titles table
    titlesroot = catalog['titles']
    crewroot = catalog['crew']
    peopleroot = catalog['people']
    for (titleid, titlerow) in step_table(db, titlesroot, 0):
        if titlerow[2] != title:
            continue
        # scan the crew table
        for (crewid, crewrow) in step_table(db, crewroot, 0):
            if crewrow[0] != titleid:
                continue
            # stab the people table
            (peopleid, peoplerow) = next(step_table(db, peopleroot, crewrow[1]))
            print(f'rowid: {peopleid}, row: {peoplerow}')

def findPeople2(db: Database, catalog: Dict[str, int], title: str) -> None:
    titlesroot = catalog['titles']
    crewroot = catalog['crew']
    peopleroot = catalog['people']

    # scan the crew table
    for (crewid, crewrow) in step_table(db, crewroot, 0):
        # stab the title table
        (titleid, titlerow) = next(step_table(db, titlesroot, crewrow[0]))
        if titlerow[2] != title:
            continue
        # stab the people table
        (peopleid, peoplerow) = next(step_table(db, peopleroot, crewrow[1]))
        print(f'rowid: {peopleid}, row: {peoplerow}')

def findPeopleIndex(db: Database, catalog: Dict[str, int], title: str) -> None:
    titlesroot = catalog['titles']
    crewroot = catalog['crew']
    peopleroot = catalog['people']
    titleindexroot = catalog['titles_by_primary_title']
    crewindexroot = catalog['crew_by_title_and_person']

    # do an index lookup to find the title
    for (primary_title, title_id) in step_index(db, titleindexroot, (title,)):
        if primary_title != title:
            break
        # do an index lookup to find crew entries
        for (ctitle_id, cperson_id, crowid) in step_index(db, crewindexroot, (title_id,)):
            if ctitle_id != title_id:
                break

            # stab the crew table
            (crewid, crewrow) = next(step_table(db, crewroot, crowid))

            # stab the people table
            (peopleid, peoplerow) = next(step_table(db, peopleroot, crewrow[1]))
            print(f'rowid: {peopleid}, row: {peoplerow}')

def findPeopleCoveringIndex(db: Database, catalog: Dict[str, int], title: str) -> None:
    titlesroot = catalog['titles']
    peopleroot = catalog['people']
    titleindexroot = catalog['titles_by_primary_title']
    crewindexroot = catalog['crew_by_title_and_person']

    # do an index lookup to find the title
    for (primary_title, title_id) in step_index(db, titleindexroot, (title,)):
        if primary_title != title:
            break
        # do an index lookup to find crew entries
        for (ctitle_id, cperson_id, crowid) in step_index(db, crewindexroot, (title_id,)):
            if ctitle_id != title_id:
                break

            # stab the people table
            (peopleid, peoplerow) = next(step_table(db, peopleroot, cperson_id))
            print(f'rowid: {peopleid}, row: {peoplerow}')
