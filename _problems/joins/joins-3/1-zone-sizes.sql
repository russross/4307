--
-- write a SQL query to count the number of rooms in each zone
-- of the world, showing the largest zones first (use the zone name as a
-- tie-breaker).
--
SELECT zones.name AS zone_name, COUNT(1) as room_count
FROM zones JOIN rooms ON zones.id = rooms.zone_id
GROUP BY zone_name
ORDER BY room_count DESC, zone_name;
