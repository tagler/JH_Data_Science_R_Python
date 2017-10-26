# PROBLEM 1 and 2 -------------------------------------------------

def overlap(a, b, min_length=3):
    """ Return length of longest suffix of 'a' matching
        a prefix of 'b' that is at least 'min_length'
        characters long.  If no such overlap exists,
        return 0. """
    start = 0  # start all the way at the left
    while True:
        start = a.find(b[:min_length], start)  # look for b's suffx in a
        if start == -1:  # no more occurrences to right
            return 0
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            return len(a)-start
        start += 1  # move just past previous match

import itertools

def scs(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = None
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        if shortest_sup is None or len(sup) < len(shortest_sup):
            shortest_sup = sup  # found shorter superstring
    return shortest_sup  # return shortest

def scs2(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    strings = []
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        strings.append(sup)
    lengths = []
    for x in strings:
        lengths.append( len(x) )
    min_length = min(lengths)
    results = []
    for y in strings:
        if len(y) == min_length:
            results.append(y)
    return set(results)

s = ['CCT', 'CTT', 'TGC', 'TGG', 'GAT', 'ATT']
scs(s)
len( scs(s) )

# PROBLEM 3 and 4 ------------------------------------------------------------

def readFastq(filename):
    sequences = []
    qualities = []
    with open(filename) as fh:
        while True:
            fh.readline()  # skip name line
            seq = fh.readline().rstrip()  # read base sequence
            fh.readline()  # skip placeholder line
            qual = fh.readline().rstrip() # base quality line
            if len(seq) == 0:
                break
            sequences.append(seq)
            qualities.append(qual)
    return sequences, qualities

def overlap(a, b, min_length=3):
    """ Return length of longest suffix of 'a' matching
        a prefix of 'b' that is at least 'min_length'
        characters long.  If no such overlap exists,
        return 0. """
    start = 0  # start all the way at the left
    while True:
        start = a.find(b[:min_length], start)  # look for b's suffx in a
        if start == -1:  # no more occurrences to right
            return 0
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            return len(a)-start
        start += 1  # move just past previous match

import itertools

def scs(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = None
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        if shortest_sup is None or len(sup) < len(shortest_sup):
            shortest_sup = sup  # found shorter superstring
    return shortest_sup  # return shortest

from collections import defaultdict

def pick_maximal_overlap(reads, k):
    """ Return a pair of reads from the list with a
        maximal suffix/prefix overlap >= k.  Returns
        overlap length 0 if there are no such overlaps."""
    reada, readb = None, None
    best_olen = 0

    sets = {}
    for s in seq:
        read_length = len(s)
        loops = read_length - k
        read_set = set()
        for x in range(0,loops):
            kmer = s[x:x+k]
            read_set.add(kmer)
        sets[s] = read_set

    for a, b in itertools.permutations(reads, 2):

        if a not in sets:
            read_set = set()
            for x in range(0, len(a)-k ):
                kmer = a[x:x+k]
                read_set.add(kmer)
                sets[a] = read_set

        if b[:k] in sets[a]:
            olen = overlap(a, b, min_length=k)
            if olen > best_olen:
                reada, readb = a, b
                best_olen = olen
    return reada, readb, best_olen

def greedy_scs(reads, k):
    """ Greedy shortest-common-superstring merge.
        Repeat until no edges (overlaps of length >= k)
        remain. """
    read_a, read_b, olen = pick_maximal_overlap(reads, k)
    while olen > 0:
        reads.remove(read_a)
        reads.remove(read_b)
        reads.append(read_a + read_b[olen:])
        read_a, read_b, olen = pick_maximal_overlap(reads, k)
    return ''.join(reads)

t = readFastq('ads1_week4_reads.fq')
seq = t[0]

z = greedy_scs(seq,30)

base_A = 0
base_C = 0
base_G = 0
base_T = 0
for base in z:
    if base == 'A':
        base_A += 1
    if base == 'C':
        base_C += 1
    if base == 'G':
        base_G += 1
    if base == 'T':
        base_T += 1
