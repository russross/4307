Performing the join using an index
----------------------------------

Write a new function in `query.py` with the following name and type:

    def findPeopleIndex(db: Database, catalog: Dict[str, int], title: str) -> None:

This performs the same join as before, but this time makes use of
the indices:

    CREATE INDEX titles_by_primary_title ON titles (primary_title);
    CREATE INDEX crew_by_title_and_person ON crew (title_id, person_id);

For now we are going to ignore the `person_id` field of the
`crew_by_title_and_person` index and use the following query plan:

*   Use an index lookup to find the title ID.

*   For each match, do an index lookup (using the title ID) to find
    the linked crew records. Remember to scan all matching records
    until you find a mismatch—that is how you will know you have
    found all matches.

*   Using the rowid from the index (remember that an index maps the
    values specified in its creation statement to a rowid of the
    table being indexed), perform a stabbing query to find the crew
    record.

*   Using the person ID from the crew record, perform a stabbing
    query to find the matching person record and print it out in the
    same format as before.
