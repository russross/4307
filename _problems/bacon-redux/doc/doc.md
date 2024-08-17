Implement the Bacon number query in query.py.

You should follow this query plan:

    QUERY PLAN
    |--MATERIALIZE bacon
    |  |--SETUP
    |  |  `--SEARCH people USING COVERING INDEX people_by_name (name=?)
    |  `--RECURSIVE STEP
    |     |--SCAN bacon
    |     |--SEARCH old USING COVERING INDEX crew_by_person_and_title (person_id=?)
    |     `--SEARCH new USING COVERING INDEX crew_by_title_and_person (title_id=?)
    |--SCAN people USING COVERING INDEX people_by_name
    |--SEARCH bacon USING AUTOMATIC COVERING INDEX (person_id=?)
    `--USE TEMP B-TREE FOR ORDER BY

Start by creating a set that will contain `(person_id, bacon_n)`
pairs to represent the `bacon` table that is built recursively:

    bacon = set()

Next to a search using the covering index `people_by_name` to find
Kevin Bacon's `person_id` (his name is passed in as an argument) and
store it along with his number:

    bacon.add( (person_id, 0) )

Since this is an index search and the name is not guaranteed to be
unique, you should continue scanning until you find a person with a
different name.

Now begin the recursive step. This should repeat until you do not
find any new entries:

*   Create a new set to gather new entries:

        new_bacon = set()

*   Scan the `bacon` set (using a `for` loop)

    *   Skip entries where `bacon_n` >= 4

    *   For each entry, use the `crew_by_person_and_title` covering
        index to find all titles the person was involved with

        *   For each title, use the `crew_by_title_and_person`
            covering index to find all people that worked on the
            title

            *   Skip entries where the person from the bacon set and
                the person from `crew_by_title_and_person` are the
                same

            *   For each person, add an entry to `new_bacon` for
                that person and `bacon_n + 1`

*   Merge the new entries with the old using `bacon |= new_bacon`,
    which sets `bacon` to be the union of the two sets.

*   If the resulting set is the same size as before, break out of
    the recursive step, otherwise repeat

Now that you have collected all of the Bacon numbers, perform the
outer step where you take the minimum Bacon number for each person
and look up each person's name (all of the recursive step was done
with `person_id`s only).

*   First, in Python, take the `bacon` set and transform it into a
    dictionary mapping each `person_id` to the minimum Bacon number.

*   Next, scan the entire `people_by_name` covering index to find
    names and ids for all of the people.

    *   For each person, see if the `person_id` is in your
        dictionary. If so, add a tuple of this form to the final
        list of result rows:

            (person_id, name, n)

        where `n` is the Bacon number.

*   Sort the final list of rows by `n`, then by `name`, then by
    `person_id`.

Use the provided code to print the results.
