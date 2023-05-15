from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional, Tuple, Dict

def getCatalog(db: Database) -> Dict[str, int]:
    catalog = {}
    for (rowid, row) in step_table(db, 1, 0):
        catalog[row[1]] = row[3]
    return catalog

def incoming_rooms_basic(db: Database, catalog: Dict[str, int]) -> None:
    group_by = {}

    for (exit_rowid, exit_row) in step_table(db, catalog['exits'], 0):
        (from_room_id, from_room_row) = next(step_table(db, catalog['rooms'], exit_row[0]))
        (to_room_id, to_room_row) = next(step_table(db, catalog['rooms'], exit_row[1]))
        if from_room_row[1] == to_room_row[1]:
            continue
        (zone_id, zone_row) = next(step_table(db, catalog['zones'], to_room_row[1]))
        zone_name = zone_row[1]
        if zone_name not in group_by:
            group_by[zone_name] = 0
        group_by[zone_name] += 1
    lst = sorted(group_by.items(), key=lambda elt: (-elt[1], elt[0]))
    for pair in lst:
        print(pair)

def incoming_rooms_index(db: Database, catalog: Dict[str, int]) -> None:
    group_by = {}

    rooms = step_table(db, catalog['rooms'], 0)
    (from_room_id, from_room_row) = next(rooms)

    # walk them in lock step
    for (index_key, index_row) in step_index(db, catalog['exits_by_from_room_to_room'], (0,)):
        while from_room_id < index_row[0]:
            (from_room_id, from_room_row) = next(rooms)
        (to_room_id, to_room_row) = next(step_table(db, catalog['rooms'], index_row[1]))
        if from_room_row[1] == to_room_row[1]:
            continue
        (zone_id, zone_row) = next(step_table(db, catalog['zones'], to_room_row[1]))
        zone_name = zone_row[1]
        if zone_name not in group_by:
            group_by[zone_name] = 0
        group_by[zone_name] += 1
    lst = sorted(group_by.items(), key=lambda elt: (-elt[1], elt[0]))
    for pair in lst:
        print(pair)
