--
-- Find all sections that are not assigned to a faculty member
-- but are due to be scheduled, i.e., they have potential time
-- slots assigned to them.
--
-- Include the department that owns each section.
--

SELECT department, section
FROM section_time_slot_tags
NATURAL JOIN sections
NATURAL JOIN courses
NATURAL LEFT OUTER JOIN faculty_sections
WHERE faculty IS NULL
ORDER BY department, section;
