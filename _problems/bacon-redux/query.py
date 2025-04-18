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

    # MATERIALIZE bacon
    bacon = set()

    # SETUP
    # SEARCH people USING COVERING INDEX people_by_name (name=?)
    for [people_name, person_id] in step_index(db, people_by_name, [name]):
        if people_name != name:
            break
        bacon.add( (person_id, 0) )

    # RECURSIVE STEP
    while True:
        new_bacon = set()

        # SCAN bacon
        for (bacon_person_id, bacon_n) in bacon:
            # WHERE bacon.n < 4
            if bacon_n >= 4:
                continue

            # SEARCH old USING COVERING INDEX crew_by_person_and_title (person_id=?)
            for [old_person_id, old_title_id, old_crew_rowid] in step_index(db, crew_by_person_and_title_root, [bacon_person_id]):
                if old_person_id != bacon_person_id:
                    break

                # SEARCH new USING COVERING INDEX crew_by_title_and_person (title_id=?)
                for [new_title_id, new_person_id, new_crew_rowid] in step_index(db, crew_by_title_and_person_root, [old_title_id]):
                    if new_title_id != old_title_id:
                        break

                    # WHERE new.person_id <> old.person_id
                    if new_person_id == old_person_id:
                        continue

                    new_bacon.add( (new_person_id, bacon_n+1) )

        # merge new entries in
        old_len = len(bacon)
        bacon |= new_bacon
        if len(bacon) == old_len:
            break

    # outer query

    # map person_id to MIN bacon number
    person_to_bacon: dict[int, int] = {}
    for (person_id, n) in bacon:
        if person_id in person_to_bacon:
            person_to_bacon[person_id] = min(n, person_to_bacon[person_id])
        else:
            person_to_bacon[person_id] = n

    # SCAN people USING COVERING INDEX people_by_name
    final_rows = []
    for [people_name, person_id] in step_index(db, people_by_name, ['']):
        if person_id in person_to_bacon:
            final_rows.append( (person_id, people_name, person_to_bacon[person_id]) )

    # ORDER BY
    final_rows.sort(key=lambda elt: (elt[2], elt[1], elt[0]))

    # print the results
    print('+-----------+-----------------------------------+---+')
    print('| person_id |               name                | n |')
    print('+-----------+-----------------------------------+---+')
    for (person_id, name, n) in final_rows:
        print(f'| {person_id:<9} | {name:33} | {n} |')
    print('+-----------+-----------------------------------+---+')
