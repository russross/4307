--
-- Find the 10 states with the most expensive house prices compared to income,
-- i.e., that minimize the ratio of
-- median_household_income : owner_occupied_homes_median_value.
--
SELECT name, median_household_income, owner_occupied_homes_median_value
FROM states
ORDER BY CAST(median_household_income AS REAL) / CAST(owner_occupied_homes_median_value AS REAL) ASC LIMIT 10;
