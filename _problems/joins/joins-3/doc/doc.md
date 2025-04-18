This data set consists of the world data for a text role-play game
from the 1990s, called a MUD. There are three tables:

1.  A room is a single location in the game. Each room has a name
    and a description. In the full game, items, monsters, and other
    players would also occupy rooms, but for this data set you can
    ignore those.

2.  Exits provide connections between rooms. Each exit represents a
    single connection from one room to another, and the direction
    that the player must move from the origin room to move to the
    target room. A description is also provided for each exit.

3.  A zone is a collection of rooms making up one region of the
    game, usually with a theme and a story.

You can see the full schema in the file `.a-schema.sql`. Type "make"
to build the database and then try some sample queries to make sure
you understand the structure of the data.

You need to write two queries in the provided files, which also
include descriptions of the specific tasks.
