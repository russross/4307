#!/usr/bin/env python3

from dataclasses import dataclass
import struct
import sys
from typing import List, Tuple, Any, Union, Iterator

FILE_HEADER_SIZE = 100

INDEX_INTERIOR = 2
TABLE_INTERIOR = 5
INDEX_LEAF = 10
TABLE_LEAF = 13

page_reads = 0
table_scans = 0
index_scans = 0
rows_scanned = 0
rows_returned = 0

def report() -> None:
    global page_reads, table_scans, index_scans, rows_scanned, rows_returned
    print(f'read {page_reads} page{"" if page_reads == 1 else "s"} ' +
          f'with {table_scans} table scan{"" if table_scans == 1 else "s"} and ' +
          f'{index_scans} index scan{"" if index_scans == 1 else "s"}')
    print(f'scanned {rows_scanned} total row{"" if rows_scanned == 1 else "s"} ' +
          f'and returned {rows_returned} row{"" if rows_returned == 1 else "s"} to the client app')

@dataclass
class Header:
    header_string: str

    page_size: int
    file_format_write_version: int
    file_format_read_version: int
    bytes_reserved_at_end_of_each_page: int
    max_embedded_payload_fraction: int
    min_embedded_payload_fraction: int
    min_leaf_payload_fraction: int
    file_change_counter: int
    file_size_in_pages: int

    first_freelist_page: int
    number_of_freelist_pages: int
    schema_version_cookie: int
    schema_format_number: int

    page_cache_size: int
    vacuum_page_number: int
    text_encoding: int
    user_version: int

    auto_vacuum_mode: int
    application_id: int
    version_valid_for: int
    sqlite_version_number: int

    unused1: int
    unused2: int
    unused3: int
    unused4: int

    unused5: int

@dataclass
class Page:
    number: int
    page_type: int
    right_child: int
    cells: List[Cell]

@dataclass
class Cell:
    page_type: int
    left_child: int
    rowid: int
    fields: Tuple[Any, ...]

class Database:
    def __init__(self, filename: str):
        self.filename = filename
        self.fp = open(filename, 'rb')
        raw = self.fp.read(FILE_HEADER_SIZE)
        assert(len(raw) == FILE_HEADER_SIZE)
        self.head = unpack_file_header(raw)

    def print_header(self) -> None:
        head = self.head
        print('header string                       :', head.header_string);

        print('page size                           :', head.page_size);
        print('file format write version           :', head.file_format_write_version);
        print('file format read version            :', head.file_format_read_version);
        print('bytes reserved at end of each page  :', head.bytes_reserved_at_end_of_each_page);
        print('max embedded payload fraction       :', head.max_embedded_payload_fraction);
        print('min embedded payload fraction       :', head.min_embedded_payload_fraction);
        print('min leaf payload fraction           :', head.min_leaf_payload_fraction);
        print('file change counter                 :', head.file_change_counter);
        print('file size in pages                  :', head.file_size_in_pages);

        print('first freelist page                 :', head.first_freelist_page);
        print('number of freelist pages            :', head.number_of_freelist_pages);
        print('schema version cookie               :', head.schema_version_cookie);
        print('schema format number                :', head.schema_format_number);

        print('page cache size                     :', head.page_cache_size);
        print('vacuum page number                  :', head.vacuum_page_number);
        print('text encoding                       :', head.text_encoding);
        print('user version                        :', head.user_version);

        print('auto vacuum mode                    :', head.auto_vacuum_mode);
        print('application id                      :', head.application_id);
        print('version valid for                   :', head.version_valid_for);
        print('sqlite version number               :', head.sqlite_version_number);

    def load_page(self, number: int) -> Page:
        global page_reads
        page_reads += 1
        self.fp.seek((number - 1) * self.head.page_size)
        raw = self.fp.read(self.head.page_size)
        assert(len(raw) == self.head.page_size)
        return unpack_page(raw, number)

class Unpacker:
    def __init__(self, raw: bytes, size: int, cursor: int = 0):
        assert(size >= 0)
        assert(cursor >= 0)
        assert(cursor <= size)
        assert(size <= len(raw))
        self.raw = raw
        self.size = size
        self.cursor = cursor

    def unpack_string(self, length: int) -> str:
        assert(self.cursor + length <= self.size)
        s = self.raw[self.cursor : self.cursor+length]
        self.cursor += length
        return s.decode('utf-8')

    def unpack_blob(self, length: int) -> bytes:
        assert(self.cursor + length <= self.size)
        b = self.raw[self.cursor : self.cursor+length]
        self.cursor += length
        return b

    def unpack_uint8(self) -> int:
        assert(self.cursor + 1 <= self.size)
        partial: int = struct.unpack('B', self.raw[self.cursor : self.cursor+1])[0]
        self.cursor += 1
        return partial

    def unpack_int8(self) -> int:
        assert(self.cursor + 1 <= self.size)
        partial: int = struct.unpack('b', self.raw[self.cursor : self.cursor+1])[0]
        self.cursor += 1
        return partial

    def unpack_uint16(self) -> int:
        assert(self.cursor + 2 <= self.size)
        partial: int = struct.unpack('!H', self.raw[self.cursor : self.cursor+2])[0]
        self.cursor += 2
        return partial

    def unpack_int16(self) -> int:
        assert(self.cursor + 2 <= self.size)
        partial: int = struct.unpack('!h', self.raw[self.cursor : self.cursor+2])[0]
        self.cursor += 2
        return partial

    def unpack_uint24(self) -> int:
        partial = self.unpack_uint16()
        return (partial << 8) | self.unpack_uint8()

    def unpack_int24(self) -> int:
        val = self.unpack_uint24()
        if val & 0x800000 != 0:
            val -= 0x1000000
        return val

    def unpack_uint32(self) -> int:
        assert(self.cursor + 4 <= self.size)
        partial: int = struct.unpack('!I', self.raw[self.cursor : self.cursor+4])[0]
        self.cursor += 4
        return partial

    def unpack_int32(self) -> int:
        assert(self.cursor + 4 <= self.size)
        partial: int = struct.unpack('!i', self.raw[self.cursor : self.cursor+4])[0]
        self.cursor += 4
        return partial

    def unpack_uint48(self) -> int:
        partial = self.unpack_uint32()
        return (partial << 16) | self.unpack_uint16()

    def unpack_int48(self) -> int:
        val = self.unpack_uint48()
        if val & 0x800000000000 != 0:
            val -= 0x1000000000000
        return val

    def unpack_uint64(self) -> int:
        assert(self.cursor + 8 <= self.size)
        partial: int = struct.unpack('!Q', self.raw[self.cursor : self.cursor+8])[0]
        self.cursor += 8
        return partial

    def unpack_int64(self) -> int:
        assert(self.cursor + 8 <= self.size)
        partial: int = struct.unpack('!q', self.raw[self.cursor : self.cursor+8])[0]
        self.cursor += 8
        return partial

    def unpack_double(self) -> float:
        assert(self.cursor + 8 <= self.size)
        partial: float = struct.unpack('!d', self.raw[self.cursor : self.cursor+8])[0]
        self.cursor += 8
        return partial

    def unpack_varint(self) -> int:
        partial = 0
        for i in range(8):
            next_byte = self.unpack_uint8()
            partial = (partial << 7) | (next_byte & 0x7f)
            if (next_byte & 0x80) == 0:
                return partial

        # special case: all 8 bits of the 9th byte are used
        partial = (partial << 8) | self.unpack_uint8()
        return partial

def print_page(page: Page) -> None:
    if page.page_type == INDEX_INTERIOR:
        print(page.number, 'is an interior index page with', len(page.cells), 'cells and right child', page.right_child)
    elif page.page_type == TABLE_INTERIOR:
        print(page.number, 'is an interior table page with', len(page.cells), 'cells and right child', page.right_child)
    elif page.page_type == INDEX_LEAF:
        print(page.number, 'is a leaf index page with', len(page.cells), 'cells')
    elif page.page_type == TABLE_LEAF:
        print(page.number, 'is a leaf table page with', len(page.cells), 'cells')

    for cell in page.cells:
        print_cell(cell)

def print_cell(cell: Cell) -> None:
    print_fields = True

    if cell.page_type == TABLE_INTERIOR:
        print('cell has left child', cell.left_child, 'and rowid', cell.rowid)
        print_fields = False
    elif cell.page_type == INDEX_INTERIOR and len(cell.fields) == 2 and type(cell.fields[0]) == int and type(cell.fields[1]) == int:
        print('cell has left child', cell.left_child, 'and is an index mapping', cell.fields[0], '->', cell.fields[1])
        print_fields = False
    elif cell.page_type == INDEX_LEAF and len(cell.fields) == 2 and type(cell.fields[0]) == int and type(cell.fields[1]) == int:
        print('cell is an index mapping', cell.fields[0], '->', cell.fields[1])
        print_fields = False
    elif cell.page_type == INDEX_INTERIOR:
        print('cell has left child', cell.left_child, 'and', len(cell.fields), 'fields')
    else:
        # print('cell has', len(cell.fields), 'fields')
        pass

    if print_fields:
        print(f'cell ({cell.rowid}: ', end='')
        for (j, field) in enumerate(cell.fields):
            if j > 0:
                print(', ', end='')
            if field is None:
                print('NULL', end='')
            elif type(field) == bytes:
                print(f'{len(field)}-byte blob', end='')
            elif type(field) == str and field.find('\n') >= 0:
                print(f'"""\n{field}\n"""', end='')
            elif type(field) == str:
                print(f'"{field}"', end='')
            else:
                print(field, end='')
        print(')')

def unpack_file_header(raw: bytes) -> Header:
    ss = Unpacker(raw, FILE_HEADER_SIZE)
    head = Header(
        ss.unpack_string(16),   # header_string

        ss.unpack_uint16(),     # page_size
        ss.unpack_uint8(),      # file_format_write_version
        ss.unpack_uint8(),      # file_format_read_version
        ss.unpack_uint8(),      # bytes_reserved_at_end_of_each_page
        ss.unpack_uint8(),      # max_embedded_payload_fraction
        ss.unpack_uint8(),      # min_embedded_payload_fraction
        ss.unpack_uint8(),      # min_leaf_payload_fraction
        ss.unpack_uint32(),     # file_change_counter
        ss.unpack_uint32(),     # file_size_in_pages

        ss.unpack_uint32(),     # first_freelist_page
        ss.unpack_uint32(),     # number_of_freelist_pages
        ss.unpack_uint32(),     # schema_version_cookie
        ss.unpack_uint32(),     # schema_format_number

        ss.unpack_uint32(),     # page_cache_size
        ss.unpack_uint32(),     # vacuum_page_number
        ss.unpack_uint32(),     # text_encoding
        ss.unpack_uint32(),     # user_version

        ss.unpack_uint32(),     # auto_vacuum_mode
        ss.unpack_uint32(),     # application_id
        ss.unpack_uint32(),     # version_valid_for
        ss.unpack_uint32(),     # sqlite_version_number

        ss.unpack_uint32(),     # unused1
        ss.unpack_uint32(),     # unused2
        ss.unpack_uint32(),     # unused3
        ss.unpack_uint32(),     # unused4

        ss.unpack_uint32()      # unused5
    )
    assert(ss.cursor == ss.size)
    return head

def unpack_page(raw: bytes, number: int) -> Page:
    ss = Unpacker(raw, len(raw), FILE_HEADER_SIZE if number == 1 else 0)
    page_type = ss.unpack_uint8()
    assert( page_type == INDEX_INTERIOR or
            page_type == TABLE_INTERIOR or
            page_type == INDEX_LEAF or
            page_type == TABLE_LEAF)
    ss.unpack_uint16()          # free offset
    cell_count = ss.unpack_uint16()
    ss.unpack_uint16()          # cell offset
    ss.unpack_uint8()           # number of fragmented free bytes
    right_child = 0
    if page_type == INDEX_INTERIOR or page_type == TABLE_INTERIOR:
        right_child = ss.unpack_uint32()

    # parse the cells
    cells = []
    for i in range(cell_count):
        cursor = ss.unpack_uint16()
        cell = unpack_cell(page_type, raw, cursor)
        cells.append(cell)

    return Page(
        number,
        page_type,
        right_child,
        cells)

def unpack_cell(page_type: int, raw: bytes, cursor: int) -> Cell:
    ss = Unpacker(raw, len(raw), cursor)

    # left child link (interior nodes only)
    left_child = 0
    if page_type == TABLE_INTERIOR or page_type == INDEX_INTERIOR:
        left_child = ss.unpack_uint32()

    # bytes of payload (all but table interior nodes)
    record_size = 0
    if page_type != TABLE_INTERIOR:
        record_size = ss.unpack_varint()

    # rowid (table nodes only)
    rowid = 0
    if page_type == TABLE_INTERIOR or page_type == TABLE_LEAF:
        rowid = ss.unpack_varint()

    # payload (all but table interior nodes)
    fields: List[Any] = []
    if page_type != TABLE_INTERIOR:
        # make sure we do not read beyond the end of the payload
        if ss.size > ss.cursor + record_size:
            ss.size = ss.cursor + record_size

        # create a payload cursor
        payload_start = ss.cursor
        field_header_size = ss.unpack_varint()
        payload_start += field_header_size
        vv = Unpacker(ss.raw, ss.size, payload_start)

        while ss.cursor < payload_start:
            type_code = ss.unpack_varint()
            if type_code == 0:
                fields.append(None)
            elif type_code == 1:
                fields.append(vv.unpack_int8())
            elif type_code == 2:
                fields.append(vv.unpack_int16())
            elif type_code == 3:
                fields.append(vv.unpack_int24())
            elif type_code == 4:
                fields.append(vv.unpack_int32())
            elif type_code == 5:
                fields.append(vv.unpack_int48())
            elif type_code == 6:
                fields.append(vv.unpack_int64())
            elif type_code == 7:
                fields.append(vv.unpack_double())
            elif type_code == 8:
                fields.append(0)
            elif type_code == 9:
                fields.append(1)
            elif type_code == 10 or type_code == 11:
                assert(type_code != 10 and type_code != 11)
            else:
                if (type_code & 1) == 0:
                    # blob
                    length = (type_code - 12) // 2
                    fields.append(vv.unpack_blob(length))
                else:
                    # text
                    length = (type_code - 13) // 2
                    fields.append(vv.unpack_string(length))

    # overflow link if applicable (all but table interior nodes)
    # we ignore this possibility
    return Cell(
        page_type,
        left_child,
        rowid,
        tuple(fields))

def step_table(db: Database, root: int, key: int) -> Iterator[Tuple[Any, ...]]:
    global table_scans
    table_scans += 1

    def search(root: int) -> Iterator[Tuple[Any, ...]]:
        global rows_scanned, rows_returned
        page = db.load_page(root)
        assert(page.page_type in (TABLE_LEAF, TABLE_INTERIOR))

        for (index, cell) in enumerate(page.cells):
            rows_scanned += 1
            cell_key = cell.rowid
            if cell_key >= key:
                if page.page_type == TABLE_LEAF:
                    rows_returned += 1
                    yield (cell_key, cell.fields)
                elif page.page_type == TABLE_INTERIOR:
                    yield from search(cell.left_child)
        if page.page_type == TABLE_INTERIOR:
            yield from search(page.right_child)

    return search(root)

def step_index(db: Database, root: int, key: Tuple[Any, ...]) -> Iterator[Tuple[Any, ...]]:
    global index_scans
    index_scans += 1

    def search(root: int) -> Iterator[Tuple[Any, ...]]:
        global rows_scanned, rows_returned
        page = db.load_page(root)
        assert(page.page_type in (INDEX_LEAF, INDEX_INTERIOR))

        for (index, cell) in enumerate(page.cells):
            rows_scanned += 1
            cell_key = cell.fields[:len(key)]
            if cell_key >= key:
                if page.page_type == INDEX_LEAF:
                    rows_returned += 1
                    yield (cell_key, cell.fields[len(key):])
                elif page.page_type == INDEX_INTERIOR:
                    yield from step_index(db, cell.left_child, key)
                    rows_returned += 1
                    yield (cell_key, cell.fields[len(key):])
        if page.page_type == INDEX_INTERIOR:
            yield from step_index(db, page.right_child, key)

    return search(root)

def main() -> None:
    db = Database('test.db')
    if len(sys.argv) == 1:
        db.print_header()
    elif len(sys.argv) == 2:
        number = int(sys.argv[1])
        page = db.load_page(number)
        print_page(page)
    elif len(sys.argv) == 3:
        number = int(sys.argv[1])
        key = int(sys.argv[2])
        for elt in step_table(db, number, key):
            print(elt)
    report()

main()
