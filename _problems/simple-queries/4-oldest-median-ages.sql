--
-- Find the 10 states with the oldest median ages.
--
SELECT name, median_age
FROM states
ORDER BY median_age DESC LIMIT 10;
