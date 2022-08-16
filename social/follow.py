#!/usr/bin/env python3

import sqlite3
import sys

# ./follow.py my_email their_email
(me, them) = sys.argv[1:3]

con = sqlite3.connect('tweater.db')
cur = con.cursor()

cur.execute('INSERT INTO follows (name, email) VALUES (?, ?)', [name, email])
con.commit()
con.close()
