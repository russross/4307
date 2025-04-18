--
-- Find the number of sections belonging to each department that can
-- be scheduled in each building.
--

SELECT building, department, COUNT(DISTINCT section) AS count
FROM rooms
NATURAL JOIN rooms_room_tags
NATURAL JOIN room_tags
NATURAL JOIN section_room_tags
NATURAL JOIN sections
NATURAL JOIN courses
GROUP BY building, department;
