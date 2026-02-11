CS 4307: Database Systems
=========================

Broadly speaking, this course approaches databases from two perspectives:

1.  Using and designing relational databases with SQL
2.  The design of modern RDBMS systems, including on-disk representation with
    btrees, query execution, transaction processing, concurrency control, etc.

Topics
------

*   Intro to SQL
*   The relational model
*   Views and indexes
*   CTE and recursive queries
*   Relation design and normalization
*   The BTree and its implementation in SQLite
*   Navigating btrees using coroutines
*   Implementing queries directly on the BTrees
*   The standard subsystems of modern RDBMS engines
*   Transaction control, logging
*   Concurrency control

Slides
------

*   [Week one: intro to the relational model](week1.pdf)
*   [Week two: anatomy of a SQL query](week2.pdf)
*   [Textbook chapter 2: Intro to Relational Model](ch2.pdf)
*   [Textbook chapter 3: Introduction to SQL](ch3.pdf)
*   [Textbook chapter 4: Intermediate SQL](ch4.pdf)

Misc
----

* [Recursive CTE example](https://gist.github.com/jbrown123/b65004fd4e8327748b650c77383bf553)
