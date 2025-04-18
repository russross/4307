from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional

def getCatalog(db: Database) -> dict[str, int]:
    catalog = {}
    for row in step_table(db, 1, 0):
        catalog[row[2]] = row[4]
    return catalog

def incoming_rooms_basic(db: Database, catalog: dict[str, int]) -> None:
    group_by = {}

    for [exit_rowid, from_room_id, to_room_id, direction, description] in step_table(db, catalog['exits'], 0):
        [f_id, _, f_zone_id, f_name, f_description] = next(step_table(db, catalog['rooms'], from_room_id))
        assert(from_room_id == f_id)
        [t_id, _, t_zone_id, t_name, t_description] = next(step_table(db, catalog['rooms'], to_room_id))
        assert(to_room_id == t_id)
        if f_zone_id == t_zone_id:
            continue
        [zone_id, _, zone_name] = next(step_table(db, catalog['zones'], t_zone_id))
        if zone_name not in group_by:
            group_by[zone_name] = 0
        group_by[zone_name] += 1
    lst = sorted(group_by.items(), key=lambda elt: (-elt[1], elt[0]))
    for pair in lst:
        print(pair)

def incoming_rooms_index(db: Database, catalog: dict[str, int]) -> None:
    group_by = {}

    rooms = step_table(db, catalog['rooms'], 0)
    [from_room_id, _, from_zone_id, from_name, from_description] = next(rooms)

    # walk them in lock step
    for [idx_from_room_id, idx_to_room_id, idx_exit_rowid] in step_index(db, catalog['exits_by_from_room_to_room'], [0]):
        while from_room_id < idx_from_room_id:
            [from_room_id, _, from_zone_id, from_name, from_description] = next(rooms)
        [to_room_id, _, to_zone_id, to_name, to_description] = next(step_table(db, catalog['rooms'], idx_to_room_id))
        if from_zone_id == to_zone_id:
            continue
        [zone_id, _, zone_name] = next(step_table(db, catalog['zones'], to_zone_id))
        if zone_name not in group_by:
            group_by[zone_name] = 0
        group_by[zone_name] += 1
    lst = sorted(group_by.items(), key=lambda elt: (-elt[1], elt[0]))
    for pair in lst:
        print(pair)
