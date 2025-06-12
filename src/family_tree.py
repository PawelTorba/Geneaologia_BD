
#!/usr/bin/env python3
"""family_tree.py
Generates a graphical family tree (PNG) for a given person ID
using the schema and functions provided in the sample database.

Requirements
------------
pip install psycopg2-binary graphviz

You also need Graphviz binaries installed on your system
(https://graphviz.org/download/) so that the `dot` command is available.

Usage
-----
python family_tree.py 13 --db genealogy --user postgres --password secret
The script will create `family_tree_<PERSON_ID>.png` in the current folder.

Depth
-----
By default the script goes 3 generations up and 2 down.
You can change that with --up N and --down M.
"""

import argparse
import os
import sys
from collections import deque, defaultdict
from typing import Dict, Set, Tuple, List

import psycopg2
from graphviz import Digraph

# ------------------------- DB helpers ---------------------------

PARENT_CODES = {5, 6}      # ojciec / matka
CHILD_CODES  = {9, 10}     # syn / córka
SIBLING_CODE = 8           # rodzeństwo
SPOUSE_TYPES = {'małżeństwo', 'ślub'}  # anything you classify as spousal

def get_connection(args):
    return psycopg2.connect(
        dbname=args.db,
        user=args.user,
        password=args.password,
        host=args.host,
        port=args.port
    )

def fetch_person(cur, person_id) -> Tuple[str, str]:
    cur.execute("""SELECT Imie, Nazwisko FROM Osoby WHERE ID_Osoba = %s""", (person_id,))
    row = cur.fetchone()
    if not row:
        raise ValueError(f"Person ID {person_id} not found")
    return row  # (Imie, Nazwisko)

def fetch_parents(cur, person_id) -> List[int]:
    cur.execute(
        """SELECT ID_Osoba_2 FROM Osoby_Pokrewienstwa
             WHERE ID_Osoba_1 = %s AND ID_Pokrewienstwo IN (5,6)""", (person_id,))
    return [r[0] for r in cur.fetchall()]

def fetch_children(cur, person_id) -> List[int]:
    cur.execute(
        """SELECT ID_Osoba_1 FROM Osoby_Pokrewienstwa
             WHERE ID_Osoba_2 = %s AND ID_Pokrewienstwo IN (9,10)""", (person_id,))
    return [r[0] for r in cur.fetchall()]

def fetch_spouses(cur, person_id) -> List[int]:
    cur.execute(
        """SELECT oz2.ID_Osoba
             FROM Osoby_Zwiazki oz1
             JOIN Osoby_Zwiazki oz2 ON oz1.ID_Zwiazek = oz2.ID_Zwiazek
             JOIN Zwiazki z ON z.ID_Zwiazek = oz1.ID_Zwiazek
             WHERE oz1.ID_Osoba = %s AND oz2.ID_Osoba <> %s
               AND z.Typ_Relacji IN ('małżeństwo','ślub')""", (person_id, person_id))
    return [r[0] for r in cur.fetchall()]

def fetch_full_name_cache(cur) -> Dict[int, str]:
    cur.execute("SELECT ID_Osoba, Imie || ' ' || Nazwisko FROM Osoby")
    return dict(cur.fetchall())

# ---------------------- Tree construction -----------------------

def build_tree(conn, root_id:int, up:int=3, down:int=2):
    """Returns edges (parent->child) and spouse edges for Graphviz"""
    edges: Set[Tuple[int,int]] = set()
    spouses: Set[Tuple[int,int]] = set()
    visited: Set[int] = set([root_id])
    name_cache = fetch_full_name_cache(conn.cursor())

    # BFS upwards (ancestors)
    up_queue = deque([(root_id, 0)])
    cur = conn.cursor()
    while up_queue:
        pid, depth = up_queue.popleft()
        if depth >= up: continue
        for parent in fetch_parents(cur, pid):
            if parent:
                edges.add( (parent, pid) )
                if parent not in visited:
                    visited.add(parent)
                    up_queue.append((parent, depth+1))
    # BFS downwards (descendants)        
    down_queue = deque([(root_id, 0)])
    cur2 = conn.cursor()
    while down_queue:
        pid, depth = down_queue.popleft()
        if depth >= down: continue
        for child in fetch_children(cur2, pid):
            if child:
                edges.add( (pid, child) )
                if child not in visited:
                    visited.add(child)
                    down_queue.append((child, depth+1))

    # spouses (only direct)
    cur3 = conn.cursor()
    for pid in list(visited):
        for spouse in fetch_spouses(cur3, pid):
            pair = tuple(sorted((pid, spouse)))
            spouses.add(pair)
            visited.add(spouse)  # ensure label appears

    return edges, spouses, name_cache

# --------------------- Graph rendering --------------------------

def render_graph(root_id:int, edges:Set[Tuple[int,int]], spouses:Set[Tuple[int,int]], names:Dict[int,str], output:str):
    g = Digraph('FamilyTree', format='png')
    g.attr(rankdir='TB', size='8,10')
    # nodes
    for pid in names:
        if pid in names:
            label = names[pid]
            if pid == root_id:
                g.node(str(pid), label, shape='doublecircle', style='filled', fillcolor='lightblue')
            else:
                g.node(str(pid), label, shape='ellipse')
    # parent-child edges
    for parent, child in edges:
        g.edge(str(parent), str(child))
    # spouse edges (undirected)
    for a, b in spouses:
        g.edge(str(a), str(b), dir='none', color='gray')
    g.render(output, cleanup=True)
    print(f"Family tree saved to {output}.png")

# ----------------------- CLI ------------------------------------

def parse_args():
    p = argparse.ArgumentParser(description='Generate a family‑tree diagram.')
    p.add_argument('person_id', type=int, help='ID_Osoba of the root person')
    p.add_argument('--db', default='genealogy')
    p.add_argument('--user', default='postgres')
    p.add_argument('--password', default='postgres')
    p.add_argument('--host', default='localhost')
    p.add_argument('--port', default=5432, type=int)
    p.add_argument('--up', default=3, type=int, help='Generations up (ancestors)')
    p.add_argument('--down', default=2, type=int, help='Generations down (descendants)')
    return p.parse_args()

def main():
    args = parse_args()
    conn = get_connection(args)
    try:
        edges, spouses, names = build_tree(conn, args.person_id, args.up, args.down)
        filename = f"family_tree_{args.person_id}"
        render_graph(args.person_id, edges, spouses, names, filename)
    finally:
        conn.close()

if __name__ == '__main__':
    main()
