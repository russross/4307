--
-- The following are taken from the slides for chapter 2 of the textbook
--

--
-- write a SQL query equivalent to the following relational algebra query:
--
--    ∏ course_id (σ semester=“Fall” Λ year=2017 (section)) ∪
--    ∏ course_id (σ semester=“Spring” Λ year=2018 (section))
--
-- the output should look like:
--
--    course_id
--    ----------
--    CS-101
--    CS-315
--    CS-319
--    CS-347
--    FIN-201
--    HIS-351
--    MU-199
--    PHY-101
--
-- write your query on the next line


--
-- write a SQL query equivalent to the following relational algebra query:
--
--    ∏ course_id (σ semester=“Fall” Λ year=2017 (section)) ∩
--    ∏ course_id (σ semester=“Spring” Λ year=2018 (section))
--
-- the output should look like:
--
--    course_id
--    ----------
--    CS-101
--
-- write your query on the next line


--
-- write a SQL query equivalent to the following relational algebra query:
--
--    ∏ course_id (σ semester=“Fall” Λ year=2017 (section)) -
--    ∏ course_id (σ semester=“Spring” Λ year=2018 (section))
--
-- the output should look like:
--
--    course_id
--    ----------
--    CS-347
--    PHY-101
--
-- write your query on the next line

