--
-- Find all sections that are unscheduled, any that are not
-- assigned time slots.
--

SELECT sections.section AS section
FROM sections
NATURAL LEFT OUTER JOIN section_time_slot_tags
WHERE time_slot_tag IS NULL
ORDER BY section;
