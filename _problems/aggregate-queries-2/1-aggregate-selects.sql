--
-- Write a SELECT query after each description below that provides the
-- requested data.
--
-- The database schema is given in the file .a-schema.sql, or you can
-- ask the database to report the schema to you. To load an interactice SQL
-- shell, use:
--
--    make shell
--
-- Within the shell you can see the schema for the "states" table by typing:
--
--    .schema states
--
-- If you want to see the complete schema for all tables, use:
--
--    .schema
--
-- Try each query out interactively first, then copy it into this file.
--
-- Note: the expected output of all queries appear in the outputs/ directory.
-- Some details are omitted from the instructions and you are expected to
-- figure them out by looking at the expected output.
--

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
