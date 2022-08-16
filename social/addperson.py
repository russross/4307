#!/usr/bin/env python3

import sqlite3
import sys

# ./addperson.py name email
(name, email) = sys.argv[1:3]

con = sqlite3.connect('tweater.db')
cur = con.cursor()

cur.execute('INSERT INTO people (name, email) VALUES (?, ?)', [name, email])
con.commit()
con.close()
