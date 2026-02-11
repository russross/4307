--
-- Find the 10 states with the youngest median ages.
--
SELECT name, median_age
FROM states
ORDER BY median_age ASC LIMIT 10;
