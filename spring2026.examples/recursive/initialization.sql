DROP TABLE IF EXISTS users;
DROP VIEW IF EXISTS bp;

CREATE TABLE users (name, cn, title, manager);
CREATE VIEW bp AS
    -- create a CTE (common table expression)
    -- think of this as creating a temporary table that only exists during this query
    -- works somewhat like CREATE TEMPORARY TABLE bosspath(cn, path)
    WITH RECURSIVE bosspath(cn,path) AS
    (
        -- initial select statement to get started
        -- this is only executed once
        -- in this case we are starting at the 'root' of the management tree
        --   the record with no manager
        SELECT cn,name FROM users WHERE manager=''

        -- merge those results with the following query
        UNION ALL

        -- recursive select statement
        -- executed repeatedly until there are no more results
        SELECT users.cn,users.name||' > '||bosspath.path
            FROM users
            JOIN bosspath ON users.manager=bosspath.cn
    )

    -- now query the CTE to produce results
    -- think of 'bosspath' as being a (very) temporary table
    SELECT users.*,bosspath.path FROM users JOIN bosspath ON users.manager=bosspath.cn;

.mode csv
.import sampledata.csv users
