--
-- Find the states where a minority of residents are white.
-- List the states from most populous to least populous.
--
SELECT name, total_population, white
FROM states
WHERE white*2 < total_population
ORDER BY total_population DESC;
