from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional, Tuple
import sys

FILENAME = 'database.db'

def main() -> None:
    line = input().strip()
    db = Database(FILENAME)

    if line == 'header':
        db.print_header()
        return

    if len(line.split()) == 1:
        number = int(line)
        page = db.load_page(number)
        print_page(page)
        return

    task = line.split(maxsplit=2)
    if len(task) == 3 and task[0] == 'table':
        number = int(task[1])
        rest = task[2].split()
        key = int(rest[0])
        if len(rest) == 1:
            end: Optional[int] = None
        elif len(rest) == 2:
            end = int(rest[1])
        else:
            print(f'table scans must have a start rowid and option end rowid, but nothing else')
            sys.exit(1)
        for (rowid, row) in step_table(db, number, key):
            if end is not None and rowid > end: break
            print(f'rowid:{rowid} cell:{row}')
        report()
        return

    if len(task) == 3 and task[0] == 'index':
        number = int(task[1])

        # key must start and end with parentheses since it is a tuple
        if not task[2].startswith('(') or not task[2].endswith(')'):
            print('keys must be tuples with parentheses')
            sys.exit(1)

        # now check for an opening paren after the first one
        middle = task[2].find('(', 1)
        if middle < 0:
            key_tuple: Tuple[Any] = eval(task[2])
            end_tuple: Optional[Tuple[Any]] = None
        else:
            key_tuple = eval(task[2][:middle])
            end_tuple = eval(task[2][middle:])
        if type(key_tuple) is not tuple:
            print('key value must be a tuple for an index query')
            sys.exit(1)
        if type(end_tuple) is not tuple and end_tuple is not None:
            print('end value must be a tuple for an index query')
            sys.exit(1)
        for row in step_index(db, number, key_tuple):
            row_key = row[:len(key_tuple)]
            if end_tuple is not None and row_key > end_tuple: break
            print(f'cell:{row}')
        report()
        return

    print(f'Usage: expects a single line of input on stdin')
    print(f'always acts on the file {FILENAME}.')
    print(f'Input can take one of the following forms:')
    print()
    print(f'To print the file header:')
    print(f'    header')
    print(f'To dump the contents of a single page:')
    print(f'    <root_page>')
    print(f'To step a table B+-tree from a specific rowid to the end:')
    print(f'    table <table_root_page> <start_rowid>')
    print(f'To step a table B+-tree over an interval of keys (inclusive at both ends of range:')
    print(f'    table <table_root_page> <start_rowid> <end_rowid>')
    print(f'To step an index B-tree from a specific key to the end')
    print(f'(note: the key is a tuple and must not contain parentheses)')
    print(f'    index <index_root_page> <start_key>')
    print(f'To step an index B-tree over an interval of keys (inclusive at both ends of range:')
    print(f'(note: both keys are tuples and must not contain parentheses)')
    print(f'    index <index_root_page> <start_key> <end_key>')
    sys.exit(1)

    report()

main()
