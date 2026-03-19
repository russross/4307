from btree import Database
from step import step_table, step_index

def getCatalog(db: Database) -> dict[str, int]:
    catalog = {}
    for row in step_table(db, 1, 0):
        catalog[row[2]] = row[4]
    return catalog

def scanForTitle(db: Database, catalog: dict[str, int], title: str) -> None:
    root = catalog['titles']
    for title_row in step_table(db, root, 0):
        if title_row[3] != title:
            continue
        print(title_row)

def stabForTitle(db: Database, catalog: dict[str, int], title: str) -> None:
    index_root = catalog['titles_by_primary_title']
    titles_root = catalog['titles']
    for index_row in step_index(db, index_root, [title]):
        if index_row[0] != title:
            break
        title_row = next(step_table(db, titles_root, index_row[1]))
        print(title_row)

def findPeople1(db: Database, catalog: dict[str, int], title: str) -> None:
    # scan the titles table
    titles_root = catalog['titles']
    crew_root = catalog['crew']
    people_root = catalog['people']
    for title_row in step_table(db, titles_root, 0):
        if title_row[3] != title:
            continue
        # scan the crew table
        for crew_row in step_table(db, crew_root, 0):
            if crew_row[1] != title_row[0]:
                continue
            # stab the people table
            people_row = next(step_table(db, people_root, crew_row[2]))
            print(people_row)

def findPeople2(db: Database, catalog: dict[str, int], title: str) -> None:
    titles_root = catalog['titles']
    crew_root = catalog['crew']
    people_root = catalog['people']

    # scan the crew table
    for crew_row in step_table(db, crew_root, 0):
        # stab the title table
        title_row = next(step_table(db, titles_root, crew_row[1]))
        if title_row[3] != title:
            continue
        # stab the people table
        people_row = next(step_table(db, people_root, crew_row[2]))
        print(people_row)

def findPeopleIndex(db: Database, catalog: dict[str, int], title: str) -> None:
    crew_root = catalog['crew']
    people_root = catalog['people']
    title_index_root = catalog['titles_by_primary_title']
    crew_index_root = catalog['crew_by_title_and_person']

    # do an index lookup to find the title
    for [primary_title, title_id] in step_index(db, title_index_root, [title]):
        if primary_title != title:
            break
        # do an index lookup to find crew entries
        for [ctitle_id, cperson_id, crowid] in step_index(db, crew_index_root, [title_id]):
            if ctitle_id != title_id:
                break

            # stab the crew table
            crew_row = next(step_table(db, crew_root, crowid))

            # stab the people table
            people_row = next(step_table(db, people_root, crew_row[2]))
            print(people_row)

def findPeopleCoveringIndex(db: Database, catalog: dict[str, int], title: str) -> None:
    # titles_root = catalog['titles']
    people_root = catalog['people']
    title_index_root = catalog['titles_by_primary_title']
    crew_index_root = catalog['crew_by_title_and_person']

    # do an index lookup to find the title
    for [primary_title, title_id] in step_index(db, title_index_root, [title]):
        if primary_title != title:
            break
        # do an index lookup to find crew entries
        for [ctitle_id, cperson_id, crowid] in step_index(db, crew_index_root, [title_id]):
            if ctitle_id != title_id:
                break

            # stab the people table
            people_row = next(step_table(db, people_root, cperson_id))
            print(people_row)
