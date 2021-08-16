--
-- The following are taken from the slides for chapter 2 of the textbook
--

--
-- write a SQL query equivalent to the following relational algebra query:
--
--    σ dept_name=“Physics” (instructor)
--
-- the output should look like:
--
--    ID          name        dept_name   salary
--    ----------  ----------  ----------  ----------
--    22222       Einstein    Physics     95000
--    33456       Gold        Physics     87000
--
-- write your query on the next line
SELECT … ;

--
-- write a SQL query equivalent to the following relational algebra query:
--
--   σ dept_name=“Physics” ∧ salary>90,000 (instructor)
--
-- the output should look like:
--
--   ID          name        dept_name   salary
--   ----------  ----------  ----------  ----------
--   22222       Einstein    Physics     95000
--
-- write your query on the next line


--
-- write a SQL query equivalent to the following relational algebra query:
--
--   σ dept_name=building (department)
--
-- the output should look like:
--
--   dept_name   building    budget
--   ----------  ----------  ----------
--   Art         Art         40000
--
-- write your query on the next line

