from btree import Database, print_page, report
from step import step_table, step_index
from typing import Any, Optional
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
        print_page(page, number)
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
            print('table scans must have a start rowid and option end rowid, but nothing else')
            sys.exit(1)
        for rowid, *row in step_table(db, number, key):
            assert(type(rowid) is int)
            if end is not None and rowid > end:
                break
            print(f'rowid {rowid}: {row}')
        report()
        return

    if len(task) == 3 and task[0] == 'index':
        number = int(task[1])

        # key must start and end with brackets since it is a list
        if not task[2].startswith('[') or not task[2].endswith(']'):
            print('keys must be lists with brackets')
            sys.exit(1)

        # now check for an opening bracket after the first one
        middle = task[2].find('[', 1)
        if middle < 0:
            key_list: list[Any] = eval(task[2])
            end_list: Optional[list[Any]] = None
        else:
            key_list = eval(task[2][:middle])
            end_list = eval(task[2][middle:])
        if type(key_list) is not list:
            print('key value must be a list for an index query')
            sys.exit(1)
        if type(end_list) is not list and end_list is not None:
            print('end value must be a list for an index query')
            sys.exit(1)
        for row in step_index(db, number, key_list):
            row_key = row[:len(key_list)]
            if end_list is not None and row_key > end_list:
                break
            print(row)
        report()
        return

    print('Usage: expects a single line of input on stdin')
    print(f'always acts on the file {FILENAME}.')
    print('Input can take one of the following forms:')
    print()
    print('To print the file header:')
    print('    header')
    print('To dump the contents of a single page:')
    print('    <root_page>')
    print('To step a table B+-tree from a specific rowid to the end:')
    print('    table <table_root_page> <start_rowid>')
    print('To step a table B+-tree over an interval of keys (inclusive at both ends of range:')
    print('    table <table_root_page> <start_rowid> <end_rowid>')
    print('To step an index B-tree from a specific key to the end')
    print('(note: the key is a list and must not contain brackets)')
    print('    index <index_root_page> <start_key>')
    print('To step an index B-tree over an interval of keys (inclusive at both ends of range:')
    print('(note: both keys are lists and must not contain brackets)')
    print('    index <index_root_page> <start_key> <end_key>')
    sys.exit(1)

    report()

main()
