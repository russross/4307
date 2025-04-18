--
-- See doc/doc.md for an introduction.
--
-- the database schema is in the file .a-schema.sql, or you can
-- query it from with the sqlite3 shell using ".schema"
--

--
-- write a SQL query to count the number of rooms in each zone
-- of the world, showing the largest zones first (use the zone name as a
-- tie-breaker).
--
SELECT zones.name AS zone_name, COUNT(1) as room_count
FROM zones JOIN rooms ON zones.id = rooms.zone_id
GROUP BY zone_name
ORDER BY room_count DESC, zone_name;
