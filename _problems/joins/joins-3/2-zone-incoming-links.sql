--
-- write a SQL query to find how many ways there are to get into
-- each zone, i.e., how many rooms in other zones have an exit that
-- leads to a room in the zone.
--
-- list the zones with the most incoming links first, and use
-- the name of the zone as a tie-breaker.
--
SELECT zones.name AS zone_name, COUNT(1) AS incoming_exits
FROM rooms AS from_room
JOIN exits ON from_room.id = exits.from_room_id
JOIN rooms AS to_room ON exits.to_room_id = to_room.id
JOIN zones ON to_room.zone_id = zones.id
WHERE from_room.zone_id <> to_room.zone_id
GROUP BY zone_name
ORDER BY incoming_exits DESC, zone_name;
