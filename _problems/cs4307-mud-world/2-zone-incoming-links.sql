--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from with the sqlite3 shell using ".schema"
--

--
-- write a SQL query to find how many ways there are to get into
-- each zone, i.e., how many rooms in other zones have an exit that
-- leads to a room in the zone.
--
-- list the zones with the most incoming links first, and use
-- the name of the zone as a tie-breaker.
--
-- the output should look like:
--
--   zone_name                 incoming_exits
--   ------------------------  --------------
--   { All } Diku    Midgaard  19
--   { 5 10} Diku    Haon Dor  8
--   { 5 15} Copper  Miden'ni  7
--   { 5 30} Diku    Sewer     7
--   {10 25} Anon    Thalos    7
--   { 5 15} Alfa    Moria     5
--   { 1 20} Copper  Plains o  4
--   {10 25} Anon    Dwarven   4
--   {10 25} Anon    Kingdom   3
--   {10 30} Anon    High Tow  3
--   { 5 10} Alfa    Graveyar  2
--   { 5 20} Alfa    Holy Gro  2
--   ...
--
-- write your query starting on the next line
SELECT zones.name AS zone_name, COUNT(1) AS incoming_exits
FROM rooms AS from_room
JOIN exits ON from_room.id = exits.from_room_id
JOIN rooms AS to_room ON exits.to_room_id = to_room.id
JOIN zones ON to_room.zone_id = zones.id
WHERE from_room.zone_id <> to_room.zone_id
GROUP BY zone_name
ORDER BY incoming_exits DESC, zone_name;
