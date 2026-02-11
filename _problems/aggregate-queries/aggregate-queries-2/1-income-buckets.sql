--
-- Find how many people live in states with various average incomes.
-- The output should look like this:
--
--     +-------------+--------------+------------------+
--     | state_count | income_group | total_population |
--     +-------------+--------------+------------------+
--     | 8           | 70000        | 29522593         |
--     | 10          | 60000        | 90725009         |
--     | 19          | 50000        | 128906914        |
--     | ...         | ...          | ...              |
--     +-------------+--------------+------------------+
--
-- States should be grouped according to the per_capita_income into
-- $10,000 ranges. The first line of output above indicates that
-- people in 8 states (a total of 29522593 people) lived in states
-- with per_capita_income between $70,000 and $79,999.
--
-- Hint: Remember that integer division truncates any remainder. You
-- can make use of this property to group states by income range and
-- also to compute the value of the income_group column.
--
SELECT  COUNT(1) AS state_count,
        (MIN(per_capita_income)/10000)*10000 AS income_group,
        SUM(total_population) AS total_population
FROM states
GROUP BY per_capita_income / 10000
ORDER BY income_group DESC;
