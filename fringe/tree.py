#!/usr/bin/env python3

import random

class Node:
    def __init__(self, key, left, right):
        self.key = key
        self.left = left
        self.right = right

def insert(node, elt):
    if node is None:
        return Node(elt, None, None)
    elif elt < node.key:
        return Node(node.key, insert(node.left, elt), node.right)
    elif elt > node.key:
        return Node(node.key, node.left, insert(node.right, elt))
    else:
        return node

def lookup(node, elt):
    if node is None:
        return False
    elif elt < node.key:
        return lookup(node.left, elt)
    elif elt > node.key:
        return lookup(node.right, elt)
    return True

def printall(node, depth=0):
    if node is None:
        return
    printall(node.left, depth+1)
    print('---|'*depth, node.key)
    printall(node.right, depth+1)

def getall(node, depth=0):
    if node is None:
        return
    yield from getall(node.left, depth+1)
    yield ('---|'*depth, node.key)
    yield from getall(node.right, depth+1)

lst = list(range(1,20))
random.shuffle(lst)
root = None
for elt in lst:
    root = insert(root, elt)
