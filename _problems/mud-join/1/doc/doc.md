Revisiting the MUD data set
---------------------------

In an earlier project we looked at how to list all of the zones in a
MUD world data set along with how many incoming links each one had
from other zones. This required a 4-way join, which logically works
like this:

* Scan each room
* Find an exit leaving that room and linking it to another room
* Find that room and make sure it is in a different zone than the
  first
* Find the zone the second room is in and add that connection to the
  result set

  The results were then aggregated and sorted to collect and count
  all incoming links for each zone.

  In the relational algebra we start by imagining the cartesian
  product of the the four tables in question (including both
  instances of rooms in the join), then filter it down to only
  records and are linked to each other according to the join
  conditions, and finally filter that down to only those where the
  two rooms are in different zones.

  Consider how impractical it would be to execute the query this
  way. The initial cartesian product would generate one row for
  every possible combination of room, exit, room, and zone. For this
  data set that would be:

      |rooms| × |exits| × |rooms| × |zones|

or

       2566   ×  5939   ×  2566   ×   42     = 1,642,388,591,928 rows

1.6 trillion rows is too many to generate and process for a
relatively simple query. Instead, the query planner generates a
straightforward strategy:

*   Scan the entire exits table
*   For each row, follow the two room links, peforming stabbing
    queries on each to get the room records
*   Only continue if the rooms have different zone IDs
*   If they do, look up the target zone by the ID taken from the
    target room record (this is another stabbing query)
*   Since the end result only requires zone names and the count of
    incoming links, gather results into a temporary table where each
    zone name is combined with the counter of incoming links that is
    incremented each time a new link is found

Implement this query plan in `query.py` in a function called
`incoming_rooms_basic` with the following signature and type:

    def incoming_rooms_basic(db: Database, catalog: dict[str, int]) -> None:

This query plan uses no indexes and only requires a single
full-table scan of a table where every record must be examined
anyway.

As you find fresh incoming links, collect them in a Python
dictionary (as a stand-in for a temporary table), then sort the
results in descending order by number of incoming links, with the
zone name as a tie-breaker. Print each pair to the screen.

You should also copy over your `step_table` and `step_index`
functions into `step.py`.
