Optimizing the query
--------------------

When scanning the exits table, room IDs are not sorted in any
particular order. Creating an index presents an optimization
opportunity:

    CREATE INDEX exits_by_from_room_to_room ON exits (from_room_id, to_room_id);

This is a covering index for this query, but this by itself does not
help much since it just turns scanning the entire table into
scanning the entire index. However, the index is ordered by
`from_room_id`, which presents this new query strategy:

*   Scan the index and the rooms table in parallel. They are both
    ordered by a room ID, so they can be fully joined in a single
    scan through them both.
*   For each joined row, perform a stabbing query to get the second
    room record.
*   Only continue if the rooms have different zone IDs
*   If they do, look up the target zone by the ID taken from the
    target room record (this is another stabbing query)
*   Since the end only requires zone names and the count of incoming
    links, gather results into a temporary table where each zone
    name is combined with the counter of incoming links that is
    incremented each time a new link is found

The optimization is that the 5939 stabbing queries on the rooms
table for the first join (one for each entry in the exits table) is
replaced with a single scan of the 2566 records in the rooms table.
The second set of stabbing queries is still necessary, but this is
a significant reduction in work.

Here is an implementation strategy for this plan:

*   Use a normal for loop to iterate over the index
*   For each index row, look at the current room row and iterate it
    as many times as necessary to “catch up” with the index. In
    other words, step it forward as long as the room ID from the
    room table is less than the room ID from the index. This may be
    zero or more times.
*   If the two room IDs match, proceed, otherwise continue the outer
    loop to move on to the next index record.

Implement this query plan in `query.py` in a function called
`incoming_rooms_index` with the following signature and type:

    def incoming_rooms_index(db: Database, catalog: dict[str, int]) -> None:

Aggregate and sort the records as before.
