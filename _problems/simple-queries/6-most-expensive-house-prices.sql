--
-- Find the 10 states with the most expensive median house price.
--
SELECT name, owner_occupied_homes_median_value
FROM states
ORDER BY owner_occupied_homes_median_value DESC LIMIT 10;
