--
-- Write a query to find the number of in-person sections scheduled
-- for each course, but only those where there are multiple sections.
--
-- You should only consider sections that are assigned at least one
-- possible room (to rule out online sections) and are assigned at
-- least one possible time slot.
--
-- Note that time slots and rooms are assigned to sections indirectly
-- via tags, which allows a group of time slots or rooms to be
-- assigned at once.
--

SELECT course, COUNT(DISTINCT section) AS section_count
FROM sections
NATURAL JOIN section_time_slot_tags
NATURAL JOIN section_room_tags
GROUP BY course
HAVING section_count > 1
ORDER by course;
