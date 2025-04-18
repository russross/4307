BEGIN TRANSACTION;
CREATE TABLE buildings (
    building                    TEXT PRIMARY KEY
) WITHOUT ROWID;
CREATE TABLE rooms (
    room                        TEXT PRIMARY KEY,
    building                    TEXT GENERATED ALWAYS AS (SUBSTR(room, 1, INSTR(room, ' ') - 1)) VIRTUAL NOT NULL,
    room_number                 TEXT GENERATED ALWAYS AS (SUBSTR(room, LENGTH(building) + 2)) VIRTUAL NOT NULL,
    capacity                    INTEGER NOT NULL,

    CHECK (LENGTH(room_number) > 0),

    FOREIGN KEY (building) REFERENCES buildings (building) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE room_tags (
    room_tag                    TEXT PRIMARY KEY
) WITHOUT ROWID;
CREATE TABLE rooms_room_tags (
    room_tag                    TEXT NOT NULL,
    room                        TEXT NOT NULL,

    PRIMARY KEY (room_tag, room),
    FOREIGN KEY (room_tag) REFERENCES room_tags (room_tag) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room) REFERENCES rooms (room) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE time_slots (
    time_slot                   TEXT PRIMARY KEY,
    days                        TEXT GENERATED ALWAYS AS (SUBSTR(time_slot, 1, LENGTH(time_slot) - LENGTH(duration) - 5)) VIRTUAL NOT NULL,
    start_time                  INTEGER GENERATED ALWAYS AS (CAST(SUBSTR(time_slot, -(LENGTH(duration) + 5), 2) AS INTEGER) * 60 + CAST(SUBSTR(time_slot, -(LENGTH(duration) + 3), 2) AS INTEGER)) VIRTUAL NOT NULL,
    duration                    INTEGER GENERATED ALWAYS AS (CAST(SUBSTR(time_slot, INSTR(time_slot, '+')) AS INTEGER)) VIRTUAL NOT NULL,
    first_day                   INTEGER GENERATED ALWAYS AS (CAST(
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            SUBSTR(days, 1, 1), 'M','1'), 'T','2'), 'W','3'), 'R','4'), 'F','5'), 'S','6'), 'U','7') AS INTEGER)) VIRTUAL NOT NULL,

    CHECK (start_time >= 0 AND start_time % 5 = 0),
    CHECK (duration > 0 AND duration % 5 = 0),
    CHECK (start_time + duration < 24*60),
    CHECK (LENGTH(days) > 0 AND INSTR(days, '$') = 0 AND
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('$'||days,
            '$M','$'), '$T','$'), '$W','$'), '$R','$'), '$F','$'), '$S','$'), '$U','$') = '$'),
    CHECK (days || SUBSTR('00'||CAST(start_time / 60 AS TEXT), -2) || SUBSTR('00'||CAST(start_time % 60 AS TEXT), -2) || '+' || CAST(duration AS TEXT) = time_slot)
) WITHOUT ROWID;
CREATE TABLE time_slot_tags (
    time_slot_tag               TEXT PRIMARY KEY
) WITHOUT ROWID;
CREATE TABLE time_slots_time_slot_tags (
    time_slot_tag               TEXT NOT NULL,
    time_slot                   TEXT NOT NULL,

    PRIMARY KEY (time_slot_tag, time_slot),
    FOREIGN KEY (time_slot_tag) REFERENCES time_slot_tags (time_slot_tag) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (time_slot) REFERENCES time_slots (time_slot) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE departments (
    department                  TEXT PRIMARY KEY
) WITHOUT ROWID;
CREATE TABLE programs (
    program                     TEXT PRIMARY KEY,
    department                  TEXT NOT NULL,

    FOREIGN KEY (department) REFERENCES departments (department) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE faculty (
    faculty                     TEXT PRIMARY KEY,
    department                  TEXT NOT NULL,

    FOREIGN KEY (department) REFERENCES departments (department) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE faculty_availability (
    faculty                     TEXT NOT NULL,
    day_of_week                 TEXT NOT NULL,
    start_time                  INTEGER NOT NULL,
    duration                    INTEGER NOT NULL,
    availability_priority       INTEGER,

    CHECK (day_of_week IN ('M', 'T', 'W', 'R', 'F', 'S', 'U')),
    CHECK (start_time >= 0 AND start_time % 5 = 0),
    CHECK (duration > 0 AND duration % 5 = 0),
    CHECK (start_time + duration < 24*60),
    CHECK (availability_priority IS NULL OR availability_priority >= 10 AND availability_priority < 20),

    PRIMARY KEY (faculty, day_of_week, start_time),
    FOREIGN KEY (faculty) REFERENCES faculty (faculty) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE faculty_preferences (
    faculty                     TEXT PRIMARY KEY,
    days_to_check               TEXT NOT NULL,
    days_off                    INTEGER,
    days_off_priority           INTEGER,
    evenly_spread_priority      INTEGER,
    max_gap_within_cluster      INTEGER NOT NULL,

    CHECK (INSTR(days_to_check, '$') = 0 AND
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('$'||days_to_check,
            '$M','$'), '$T','$'), '$W','$'), '$R','$'), '$F','$'), '$S','$'), '$U','$') = '$'),
    CHECK (days_off IS NULL OR days_off >= 0 AND days_off < 7),
    CHECK (days_off_priority IS NULL OR days_off_priority >= 10 AND days_off_priority < 20),
    CHECK (days_off_priority IS NULL AND days_off IS NULL OR days_off_priority IS NOT NULL AND days_off IS NOT NULL),
    CHECK (days_off_priority IS NULL OR LENGTH(days_to_check) > 1),
    CHECK (evenly_spread_priority IS NULL OR evenly_spread_priority >= 10 AND evenly_spread_priority < 20),
    CHECK (evenly_spread_priority IS NULL OR LENGTH(days_to_check) > 1),
    CHECK (max_gap_within_cluster >= 0 AND max_gap_within_cluster < 120),

    FOREIGN KEY (faculty) REFERENCES faculty (faculty) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE faculty_preference_intervals (
    faculty                     TEXT NOT NULL,
    is_cluster                  BOOLEAN NOT NULL,       -- true => cluster, false => gap
    is_too_short                BOOLEAN NOT NULL,       -- true => too short, false => too long
    interval_minutes            INTEGER NOT NULL,
    interval_priority           INTEGER,
    -- e.g., cluster shorter than 110 minutes with priority 16,
    -- or    gap     longer  than 105 minutes with priority 11

    CHECK (interval_minutes > 0 AND interval_minutes < 24*60),
    CHECK (interval_priority IS NULL OR interval_priority >= 10 AND interval_priority < 20),

    PRIMARY KEY (faculty, is_cluster, is_too_short, interval_minutes),
    FOREIGN KEY (faculty) REFERENCES faculty_preferences (faculty)
) WITHOUT ROWID;
CREATE TABLE courses (
    course                      TEXT PRIMARY KEY,
    department                  TEXT NOT NULL,
    course_name                 TEXT NOT NULL,
    prefix                      TEXT GENERATED ALWAYS AS (SUBSTR(course, 1, INSTR(course, ' ') - 1)) VIRTUAL NOT NULL,
    course_number               TEXT GENERATED ALWAYS AS (SUBSTR(course, INSTR(course, ' ') + 1)) VIRTUAL NOT NULL,

    CHECK (LENGTH(prefix) >= 1),
    CHECK (LENGTH(course_number) >= 4),

    FOREIGN KEY (department) REFERENCES departments (department) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE prereqs (
    course                      TEXT NOT NULL,
    prereq                      TEXT NOT NULL,

    PRIMARY KEY (course, prereq),
    FOREIGN KEY (course) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prereq) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE coreqs (
    course                      TEXT NOT NULL,
    coreq                       TEXT NOT NULL,

    PRIMARY KEY (course, coreq),
    FOREIGN KEY (course) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (coreq) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE sections (
    section                     TEXT PRIMARY KEY,
    course                      TEXT GENERATED ALWAYS AS (SUBSTR(section, 1, INSTR(section, '-') - 1)) VIRTUAL NOT NULL,
    section_number              TEXT GENERATED ALWAYS AS (SUBSTR(section, INSTR(section, '-') + 1)) VIRTUAL NOT NULL,

    CHECK (LENGTH(course) >= 6),
    CHECK (LENGTH(section_number) >= 2),
    CHECK (course || '-' || section_number = section),

    FOREIGN KEY (course) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE section_room_tags (
    section                     TEXT NOT NULL,
    room_tag                    TEXT NOT NULL,
    room_priority               INTEGER,

    CHECK (room_priority IS NULL OR room_priority >= 10 AND room_priority < 20),

    PRIMARY KEY (section, room_tag),
    FOREIGN KEY (section) REFERENCES sections (section) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_tag) REFERENCES room_tags (room_tag) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE section_time_slot_tags (
    section                     TEXT NOT NULL,
    time_slot_tag               TEXT NOT NULL,
    time_slot_priority          INTEGER,

    CHECK (time_slot_priority IS NULL OR time_slot_priority >= 10 AND time_slot_priority < 20),

    PRIMARY KEY (section, time_slot_tag),
    FOREIGN KEY (section) REFERENCES sections (section) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (time_slot_tag) REFERENCES time_slot_tags (time_slot_tag) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE faculty_sections (
    faculty                     TEXT NOT NULL,
    section                     TEXT NOT NULL,

    PRIMARY KEY (faculty, section),
    FOREIGN KEY (faculty) REFERENCES faculty (faculty) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (section) REFERENCES sections (section) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE conflicts (
    program                     TEXT NOT NULL,
    conflict_name               TEXT NOT NULL,
    conflict_priority           INTEGER,
    boost_priority              BOOLEAN NOT NULL,

    CHECK (conflict_priority IS NULL OR conflict_priority > 0 AND conflict_priority < 10),
    CHECK (conflict_priority IS NOT NULL OR NOT boost_priority),

    PRIMARY KEY (program, conflict_name),
    FOREIGN KEY (program) REFERENCES programs (program) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE conflict_courses (
    program                     TEXT NOT NULL,
    conflict_name               TEXT NOT NULL,
    course                      TEXT NOT NULL,

    PRIMARY KEY (program, conflict_name, course),
    FOREIGN KEY (program, conflict_name) REFERENCES conflicts (program, conflict_name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE conflict_sections (
    program                     TEXT NOT NULL,
    conflict_name               TEXT NOT NULL,
    section                     TEXT NOT NULL,

    PRIMARY KEY (program, conflict_name, section),
    FOREIGN KEY (program, conflict_name) REFERENCES conflicts (program, conflict_name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (section) REFERENCES sections (section) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
CREATE TABLE multiple_section_overrides (
    course                      TEXT PRIMARY KEY,
    section_count               INTEGER NOT NULL,

    FOREIGN KEY (course) REFERENCES courses (course) ON DELETE CASCADE ON UPDATE CASCADE
) WITHOUT ROWID;
COMMIT;
