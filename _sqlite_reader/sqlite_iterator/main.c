#include <assert.h>
#include "btree.h"
#include <fcntl.h>
#include <inttypes.h>
#include "serializer.h"
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void) {
    struct file_header head;

    // if you are loading from a file other than test.db, change this
    int fd = open("test.db", O_RDONLY);
    assert(fd >= 0);
    uint8_t *raw = must_malloc(FILE_HEADER_SIZE);
    ssize_t ret = read(fd, raw, FILE_HEADER_SIZE);
    assert(ret == FILE_HEADER_SIZE);

    /* read and unpack the header */
    unpack_file_header(raw, FILE_HEADER_SIZE, &head);
    free(raw);

    // query: select * from titles where primary_title = 'Inception'

    // note: you must set this to the root of the titles tree in your .db file
    uint32_t titles_root = 579;

    struct query_iterator *iter = query_seek(&head, fd, titles_root, 1);
    if (iter == NULL)  {
        // note: when query_seek returns NULL, it means the key was not found
        // and there is no memory allocation to worry about
        printf("not found\n");
        return 0;
    }
    int count = 0;
    do {
        struct cell *cell = query_get(iter);
        if (!strcmp((const char *) cell->fields[2].value.text.string, "Inception")) {
            print_cell(cell);
        }
        count++;
    } while (query_step(iter));

    // note: when query_step returns false, it means there are no more records
    // left and all memory from the iterator has been freed already.
    // If you finish using an iterator before query_step returns false, you must
    // call free_query_iterator on it to clean up.

    printf("found %d entries\n", count);

    int close_ret = close(fd);
    assert(close_ret >= 0);

    // report on number of steps, page loads, etc.
    report();

    return 0;
}
