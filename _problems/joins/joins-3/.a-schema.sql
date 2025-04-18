CREATE TABLE zones (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL
);
CREATE TABLE rooms (
    id              INTEGER PRIMARY KEY,
    zone_id         INTEGER NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT NOT NULL,

    FOREIGN KEY(zone_id) REFERENCES zones(id)
);
CREATE TABLE exits (
    from_room_id    INTEGER NOT NULL,
    to_room_id      INTEGER NOT NULL,
    direction       TEXT NOT NULL CHECK(direction IN ('n','e','s','w','u','d')),
    description     TEXT NOT NULL,

    PRIMARY KEY(from_room_id, direction),
    FOREIGN KEY(from_room_id) REFERENCES rooms(id),
    FOREIGN KEY(to_room_id) REFERENCES rooms(id)
);
