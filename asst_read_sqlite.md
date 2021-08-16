Reading a SQLite file
=====================

In this assignment you will write code to read and interpret data in
a SQLite database file. To simplify the task, we will only consider
SQLite files with the following restrictions:

1.  The only value types will be integers and strings.

2.  Every table must have an integer primary key field.

3.  The only indexes allowed are those mapping from integer foreign
    key to integer primary key.

4.  All rows must be small enough to not trigger the overflow
    mechanism in SQLite. That normally means a single row must not
    encode to be larger than 25% of the size of a single page.

To further simplify the task at hand, we will follow some additional
guidelines:

*   Focus on simplicity and correctness, not on performance. Rather
    than trying to work with b-tree data in place, we will generally
    decode an entire page into a series of structs that are more
    convenient to work with, then re-encode an entire page from
    those structs.

*   Use `assert` to force an immediate crash whenever you encounter
    data that is not as you expect. A real database should not panic
    and crash whenever anything unexpected happens, but you should
    do so.

An important note about `assert`: never perform any actions within
an assert statement. For example, to verify that a `close` call
returns a non-negative value, do not use:

    assert(close(fd) >= 0); /* WRONG */

Instead use:

    int ret = close(fd);
    assert(ret >= 0);

The `assert` library is designed to be turned off at compile time,
in which case everything that is part of an `assert` statement is
effectively deleted.


Integer types
-------------

In C there are some basic integer types, but their precision is up
to the compiler:

*   `char`: a signed 8-bit integer (often used for a single ASCII
    character or a generic byte value)
*   `short`: a signed integer, typically (but not necessary) 16
    bits. Guaranteed to not have more bits than an `int`.
*   `int`: a signed integer, typically (but not necessary) 32 or 64
    bits. Guaranteed to be at least as big as a `short` and no
    bigger than a `long`.
*   `long`: a signed integer that is at least as big as an `int` but
    maybe bigger.
*   `long long`: a signed integer that is at least as big as a
    `long` but maybe bigger.

You can also put `unsigned` in front of any of these (`usigned
short`) to get an unsigned variant, or use `unsigned` by itself as
an alias for `unsigned int`.

These are unhelpful if you need precise sizes. We will mostly avoid
them in favor of aliases defined in:

    #include <inttypes.h>

including:

*   `int8_t`, `uint8_t`: signed and unsigned 8-bit values
*   `int16_t`, `uint16_t`: signed and unsigned 16-bit values
*   `int32_t`, `uint32_t`: signed and unsigned 32-bit values
*   `int64_t`, `uint64_t`: signed and unsigned 64-bit values

When interacting with standard library functions, we will try to use
the integer aliases they prefer. For example, see `must_malloc`
defined below, which uses `size_t` to denote an integer suitable for
holding a size value.


Memory
------

The C standard library includes two basic functions for dynamically
allocating memory:

    #include <stdlib.h>

    void *malloc(size_t size);
    void free(void *ptr);

You can get more information about these (and other standard library
functions) by consulting the manual from a Unix prompt:

    $ man malloc

You should always check the return value of `malloc` to make sure it
succeeded. To keep things simple, use a simple wrapper function:

    #include <assert.h>
    #include <stdlib.h>

    void *must_malloc(size_t size) {
        void *ptr = malloc(size);
        assert(ptr != NULL);
        return ptr;
    }

Anything that you allocate using `malloc` must eventually be
deallocated using `free`. Running your program with `valgrind` will
help to verify that you are doing this correctly:

    $ valgrind ./a.out

You often have a choice of whether to allocate a data structure
dynamically on the heap:

    struct file_header *head = must_malloc(sizeof(struct file_header));

and eventually calling `free` on the resulting pointer, or you can
often create an instance of a data structure as an *automatic*
variable:

    struct file_header head;

In the latter case it will be allocated on the stack frame of the
current function and will automatically be deallocated when the
current function returns. This is more convenient when the lifetime
of the data structure matches the lifetime of the function, but bear
in mind that it only frees up the direct storage of the structure
itself. If `file_header` contains pointers to other heap-allocated
data, you must still manually free that data before letting the main
struct go out of scope.


Reading and writing from files
------------------------------

We will use the Unix file interface functions. All of these are
documented in section 2 of the manual, meaning you can get help
using:

    $ man 2 open

etc. You may occasionally find that you are missing a header file so
the compiler complains when you try to use a library function. When
that happens, look the function up in the manual and it will show
you which header or headers you need to include.

Here are the main functions we will use:

    int open(const char *pathname, int flags);
    int open(const char *pathname, int flags, mode_t mode);
    int creat(const char *pathname, mode_t mode);
    ssize_t read(int fd, void *buf, size_t count);
    ssize_t write(int fd, const void *buf, size_t count);
    off_t lseek(int fd, off_t offset, int whence);
    int close(int fd);

`open` lets you open an existing file (or you can create a new file
using the right flags), `creat` is a convenience version of `open`
for creating new files, `read` and `write` let you load and store
data, respectively, `lseek` lets you reposition the file (to move to
a specific location within the file, typically), and `close` signals
that you are finished accessing a file.

For this project, you will use the following basic access pattern:

1.  Open a file and read the header, or for a new file, create the
    file and write the header
2.  Keep it open while you perform a series of seeks to page
    boundaries and read/write entire pages of data from/to disk.
3.  Close the file when you are completely finished with it.


Example reading a file header
-----------------------------

Here is an example of how to read a file header containing 100
bytes:

``` c
int main(void) {
    uint8_t *raw = must_malloc(100);
    int fd = open("test.db", O_RDONLY);
    assert(fd >= 0);
    ssize_t bytes_read = read(fd, raw, 100);
    assert(bytes_read == 100);

    /* parse and process the header */

    int close_ret = close(fd);
    assert(close_ret >= 0);
    free(raw);
```


Unpacking basic values
----------------------

You will need to convert between values stored on disk (in
big-endian format) and values stored in memory (using the native
types and data structures of C, typically in little-endian format on
most modern machines). Since you will usually be reading a series of
values, I suggest starting with a struct like this:

``` c
struct serializer {
    uint8_t *base;
    uint32_t size;
    uint32_t cursor;
};
```

You could create this using `malloc` and `free`, but since scanning
data structures is often accomplished within a single helper
function, it is a good candidate for a local, stack-based value:

``` c
void unpack_file_header(uint8_t *raw, uint32_t size, struct file_header *head) {
    struct serializer ss = { .base = raw, .size = size, .cursor = 0 };
    unpack_raw_string(&ss, (uint8_t *) &head->header_string, 16);

    head->page_size = unpack_uint16(&ss);
    /* do the rest of the unpacking work */

    /* ss is automatically deallocated as part of the stack frame */
}
```

A series of helper functions can unpack specific kinds of values
from an on-disk format and convert them to a native format:

``` c
uint8_t unpack_uint8(struct serializer *ss) {
    assert(ss->cursor + 1 <= ss->size);
    return ss->base[ss->cursor++];
}

int8_t unpack_int8(struct serializer *ss) {
    return (int8_t) unpack_uint8(ss);
}
```

`unpack_uint8` is a simple one since it just loads a single byte at
returns it, but it also verifies that you have not read past the end
of the buffer and advances the cursor so the next read will occur
after the current one. Since we are using return values with
specific sizes, we can convert from an unsigned value to a signed
value simply by typecasting the value and forcing a
re-interpretation of the same bits (see `unpack_int8`).

To read larger integer values we can use something like:

``` c
uint32_t unpack_uint32(struct serializer *ss) {
    assert(ss->cursor + 4 <= ss->size);
    uint32_t partial = ss->base[ss->cursor++];
    partial = (partial << 8) | ss->base[ss->cursor++];
    partial = (partial << 8) | ss->base[ss->cursor++];
    return (partial << 8) | ss->base[ss->cursor++];
}
```

We check to make sure the entire read is within the bounds of the
data buffer we are reading from, then extract the data one byte at a
time. Each time we shift the existing value to the left 8 bits and
use the bitwise or operator to combine it with the new byte.

There are a few cases that require additional care, such as reading
signed 24-bit values or big-endian double-precision floats.

SQLite also uses a variable-length integer encoding to pack 64-bit
unsigned values into anywhere between 1 and 9 bytes. Here is code to
read and unpack them:

``` c
int64_t unpack_varint(struct serializer *ss) {
    uint64_t partial = 0;
    for (uint32_t i = 0; i < 8; i++) {
        assert(ss->cursor + i <= ss->size);
        uint8_t nextbyte = ss->base[ss->cursor++];
        partial = (partial << 7) | (nextbyte & 0x7f);
        if ((nextbyte & 0x80) == 0)
            return partial;
    }

    /* special case: all 8 bits of 9th byte are used */
    assert(ss->cursor + 8 <= ss->size);
    uint8_t nextbyte = ss->base[ss->cursor++];
    partial = (partial << 8) | nextbyte;
    return (int64_t) partial;
}
```

When unpacking raw strings (a SQLite type where the length is known
but the data is not necessarily terminated with a zero byte), there
are two forms that are useful in different circumstances:

``` c
void unpack_raw_string(struct serializer *ss, uint8_t *buffer, uint32_t length) {
    assert(ss->cursor + length <= ss->size);
    memcpy(buffer, ss->base + ss->cursor, length);
    ss->cursor += length;
}

uint8_t *unpack_raw_string_malloc(struct serializer *ss, uint32_t length) {
    uint8_t *result = must_malloc(length + 1);
    unpack_raw_string(ss, result, length);
    result[length] = 0;
    return result;
}
```

The first fetches the requested number of bytes into an existing
buffer—it is just a raw copy that advances the cursor and checks for
buffer overflows.

The second allocates space for the string (which you must track and
free eventually) and adds a zero byte on the end.

All of these and others are defined for you in the following files.
I have also included a generic `Makefile` to help build your
project. It will automatically build and link all C source files in
the directory:

* [Makefile](Makefile)
* [serializer.c](serializer.c), [serializer.h](serializer.h)



Unpacking the file header
-------------------------

You should now be ready to read and parse the header of an existing
SQLite file. The `btree.h` file linked here has a `struct` type with
all of the fields of the header in the proper order:

* [btree.h](btree.h)

The type of each value indicates how many bytes it occupies in the
packed format, and I have added a blank line every 16 bytes to help
you keep track.

Write code to read and parse the header of a SQLite file. Use the
following structure:

* `main` should:
    * define a `file_header` struct on the stack
    * open the file
    * allocate a 100-byte buffer
    * read the first 100 bytes into the buffer
    * call `unpack_file_header` to unpack the data
    * free the 100-byte buffer
    * call `print_file_header`
    * close the file
* `unpack_file_header(uint8_t *raw, uint8_t size, struct file_header *head)` should:
    * use a `serializer` to unpack all 100 bytes of the raw data into the struct
* `print_file_header(struct file_header *head)` should:
    * print all of the fields of the header in an easy-to-read
      format (skip the unused fields)
    
Run it using `valgrind` and verify that all memory is properly
managed.

To create a simple SQLite file for testing, use:

    $ sqlite3 test.db "CREATE TABLE instructors (id INTEGER PRIMARY KEY, name TEXT);"

Your output should look something like:

```
header string                       : SQLite format 3
page size                           : 4096
file format write version           : 1
file format read version            : 1
bytes reserved at end of each page  : 0
max embedded payload fraction       : 64
min embedded payload fraction       : 32
min leaf payload fraction           : 32
file change counter                 : 0
file size in pages                  : 0
first freelist page                 : 65536
number of freelist pages            : 131072
schema version cookie               : 0
file format number of schema layer  : 0
page cache size                     : 65536
vacuum incremental cursor           : 262144
text encoding                       : 0
user cookie                         : 0
auto vacuum mode                    : 65536
application id                      : 0
version valid for                   : 0
sqlite version number               : 0
```


Unpacking a b-tree node
-----------------------

The `btree.h` header linked earlier also contains definitions and
function prototypes for unpacking b-tree nodes. Full documentation
for the b-tree page, cell, and field format is given here:

* [SQLite database file format](https://www.sqlite.org/fileformat.html)

We will be ignoring the lock-byte page, freelist pages, payload
overflow pages, and pointer map pages. We are only interested in the
four varieties of b-tree pages, so you should focus on these parts
of the database file documentation:

* [1.2. Pages](https://www.sqlite.org/fileformat.html#pages)
* [1.3. The Database Header](https://www.sqlite.org/fileformat.html#the_database_header)
* [1.6. B-tree Pages](https://www.sqlite.org/fileformat.html#b_tree_pages)
* [2.1. Record Format](https://www.sqlite.org/fileformat.html#record_format)

Your goal in this part of the project will be to load a single
b-tree page into memory, unpack it into the datatypes defined in
`btree.h`, and then print that information out in a human-readable
format.

As always, I suggest an incremental development style, where you
write small pieces of code that can be tested immediately and can be
written in a short amount of time. What follows is a sequence of
steps that will help you follow this style to implement this
project.


Steps
-----

### Main

Start by re-working the main structure of your program (I suggest
writing this in a file called `main.c`) so that it does the
following:

*   Parse command-line arguments. Your program should be callable in
    one of two ways:

    1.  `./a.out`: read the file header of `test.db` and print it
        out
    2.  `./a.out 4`: read the file header of `test.db`, then read
        page 4 from disk, unpack it as a b-tree, and print
        the contents of the page

*   Open the file, allocate a buffer, read the header, unpack it,
    free the buffer

*   If the command-line arguments did not supply a page number,
    print the contents of the header, clean up, and quit

*   Otherwise, keep the file open and keep the unpacked header

*   Use `lseek` to move to the right part of the file based on the
    page number, allocate a buffer of the right size, and read the
    page in from disk.

*   For now, just print out the type of page that you have loaded.
    The very first byte of the page indicates the type of page as
    described in section 1.6 linked above. I have also defined an
    `enum` type in `btree.h` giving names to the four valid b-tree
    page types.

*   A couple of details that are easy to miss:

    1.  The first page on the disk is page 1, not page 0. When
        computing where to seek to in order to load a page, you will
        need to use `(page - 1) × page_size`

    2.  Page 1 begins at byte 100 (after the file header), while
        every other page begins at byte 0. Use the
        `FILE_HEADER_SIZE` constant defined in `btree.h` rather than
        hard-coding the magic number 100 wherever you refer to the
        header size.

*   Be sure to free any allocated memory and close the file before
    `main` finishes. Run your code using `valgrind` to check your
    memory usage so far.


### Page header

* [1.6. B-tree Pages](https://www.sqlite.org/fileformat.html#b_tree_pages)

Begin implementing the `unpack_btree_page` function that is
prototyped in `btree.h`. I suggest defining this and other functions
prototyped in `btree.h` in `btree.c`.

*   `unpack_btree_page` should start by allocating a `btree_page`
    struct that it can fill in and return. Use a `serializer` struct
    and the functions prototyped in `serializer.h` and defined in
    `serializer.c` to unpack the header of the b-tree page into the
    struct. Record the page number and unpack the `type`,
    `cell_count`, and `right_child` fields (only unpack
    `right_child` if appropriate for the page type).

*   Begin writing a `print_page` function in `main.c` that will
    eventually print all relevant information about a page based on
    a fully-filled-in `btree_page` struct. For now, just have it
    print the info that you have unpacked so far.

*   Complete the structure of `main` so it calls `unpack_btree_page`
    and `print_page` when requested, or prints the file header when
    no page is specified. Test it using `valgring` to make sure you
    are matching your `malloc` and `free` calls.

*   Test it using a few different kinds of pages. Use `sqlite3` to
    create a `test.db` file with several simple tables and indexes.
    Insert records into a table until you notice the `test.db` file
    gets bigger. This will indicate that it has had to split a page
    so you can test your code on an interior page as well. For now,
    just guess which pages are what or try all of them.

    To make this a bit easier, you may also wish to use a smaller
    page size. When you create a new database file, run:

        pragma page_size = 512;

    before your first `create` statement. With smaller pages, you
    will have more page splits so it will be easier to create more
    complex b-tree structures.


### Page cell array

The `btree_page` struct has a single pointer for an array of
`btree_cell` structs. Note that a pointer to a single element is
defined in the same way as a pointer to an array; we are using the
latter in this case.

*   Have `unpack_btree_page` allocate an array for the correct
    number of cells as specified in the page header.

Since parsing a page will eventually require allocating many chunks
of memory, you will need a systematic way of freeing everything.
`btree.h` has a prototype for a `free_btree_page` function, whose
job is to free everything associated with a `btree_page` struct
including the struct itself.

*   Implement the initial version fo `free_btree_page` to free the
    cell array as well as the page struct itself. Update `main` to
    use the appropriate functions.

*   Test everything with `valgrind` to make sure your memory
    management is correct.

The next task is to find all of the cells on the page. Recall that
the page header is followed by a list of cell pointers (see the
documentation), which are 2-byte offsets from the beginning of the
page telling where each cell is stored in the page. The cell data is
not necessarily contiguous or in order, but the cell pointers will
be.

*   In `unpack_btree_page`, unpack the cell pointers and print out
    their values to the screen for testing purposes. Try it on a few
    different pages to see if you are seeing plausible cell pointer
    values (nothing bigger than the page size), and nothing so small
    that it would point into the page header or the cell pointer
    array.

*   Create the beginnings of your `unpack_btree_cell` function as
    prototyped in `btree.h`. Have `unpack_btree_page` loop through
    the cells and call `unpack_btree_cell` on each one. When you
    call `unpack_btree_cell`, you should be giving it the location
    of the beginning of the page (`raw`, the size of the page
    (`size`), and the locationg where it begins in the page
    (`cursor`) suitable for use in a fresh `serializer`. Give it a
    pointer to the appropriate entry in the cell array allocated
    earlier as part of the page struct.

*   For now, have `unpack_btree_cell` just print out the cursor.
    When you test it, you should see the same values you saw earlier
    when printing cell offsets.


### Unpacking a cell

* [1.6. B-tree Pages](https://www.sqlite.org/fileformat.html#b_tree_pages)
* [2.1. Record Format](https://www.sqlite.org/fileformat.html#record_format)

The contents of a cell vary with the page type, as described in
section 1.6 of the documentation. Note that we are ignoring anything
to do with overflow pages, which simplifies some of the cases.

The payload portion (for all page types except interior table pages)
is described in section 2.1 and has these basic pieces:

1.  Varint with the length of the payload header
2.  A series of varints—one per field—telling the type and length of
    each payload field
3.  The payload field values in the same order as the header

One challenge is that you do not know how many fields there are
until you have read the entire header. I suggest doing the
following:

1.  Write a helper function whose job is to count the number of
    fields. If it uses its own `serializer`, then will not need to
    rewind the main `serializer` that `unpack_btree_cell` is using.
    A few details:

    *   First note where the header begins (make a copy of the
        `cursor` in the `serializer`
    *   Unpack the varint holding the header length
    *   Call your helper function, letting it know where the header
        begins and how long it is. It should just unpack varints
        from the header until it reaches the end of the header.
        Since each field is marked by a single varint in the header,
        the number it unpacks tells how many fields there are.

2.  Back in the main `unpack_btree_cell` function, allocate the
    array of field values in the cell

3.  Keep your old `serializer` that is still pointed at the
    beginning of the payload header and create a second `serializer`
    that points to the beginning of the payload field data.

4.  Unpack the fields. This can work in a single loop:

    *   Re-unpack the header field to learn what kind of value it is
        using the first serializer
    *   Unpack the value itself using the second serializer
    *   Store the value in the correct field array element

The documentation describes three kinds of values that occupy zero
bytes: NULL, a special type for the value 0, and a special type for
the value 1. For those values, reading the header tells you enough
to construct the value so you should not unpack anything else.

There are six sizes of integers described with different header
values, plus the special 0 and 1 types. Each must be unpacked in its
own way, but they can all be stored in the field struct using the
`integer` type.

For the blob and text types, you will need to allocate the
appropriate amount of space and then decode the field. Note a few
details:

*   For the blob type, allocate the exact amount of space to hold
    the value
*   For the text type, allocate one extra byte. After decoding the
    value, set the extra byte at the end to be a zero. This will
    allow you to treat this value as a C string and be confident
    that it ends with a null terminator.

Be sure to write full implementations of `free_btree_cell` and
`free_btree_page`. The `free_btree_cell` will need to free text and
blob fields as well as freeing the entire field array.
`free_btree_page` will loop over the cells and free each one using
`free_btree_cell`, then free the entire array of cells. Use valgrind
to verify that your allocation and freeing line up propoerly.


### Finishing up

Once you have the ability to unpack any of the four page types, you
should fill in any missing parts to make sure that your overall
program supports the user interface described earlier. When called
with no command-line arguments, it should print out the contents of
the file header. When given a page number, it should decode (but not
print) the file header, then load the requested page, unpack it,
print out its contents in a user-friendly format, and then free all
memory and quit.
