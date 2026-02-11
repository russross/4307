--
-- Find the per capita income of the states compared to the size of
-- the states. For example:
--
--     +-------------+------------------+-------------------+
--     | state_count | population_group | per_capita_income |
--     +-------------+------------------+-------------------+
--     | 7           | 0                | 62743             |
--     | 8           | 1000000          | 55402             |
--     | 6           | 2000000          | 49730             |
--     | 4           | 3000000          | 48357             |
--     | ...         | ...              | ...               |
--     +-------------+------------------+-------------------+
--
-- The first line indicates that there are 7 states with population
-- between 0 and 999,999, and the per capita income of those states
-- is $62,743 per year.
--
-- Note that you should not just compute the average of the
-- per_capita_income values of each states, since that would not
-- give an accurate combined figure. Instead, compute the total
-- income of each state (population × per_capita_income), add up
-- those totals, and divide by the combined population of the group
-- of states. In other words you should be dividing the total income
-- of a group of states by the total population of that group of
-- states to get the per_capita_income output column.
SELECT  COUNT(1) AS state_count,
        MIN(total_population)/1000000*1000000 AS population_group,
        SUM(per_capita_income*total_population) / SUM(total_population) AS per_capita_income
FROM states
GROUP BY total_population/1000000
ORDER BY population_group;
