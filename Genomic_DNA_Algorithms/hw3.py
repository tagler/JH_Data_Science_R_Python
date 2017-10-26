# PROBLEM 1 and 2 -----------------------------------------------

def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            # ignore header line with genome information
            if not line[0] == '>':
                genome += line.rstrip()
    return genome

t = readGenome('chr1.GRCh38.excerpt.fasta')

def editDistance(x, y):
    # Create distance matrix
    D = []
    for i in range(len(x)+1):
        D.append([0]*(len(y)+1))

    # Initialize first row and column of matrix
    for i in range(len(x)+1):
        D[i][0] = i
    for i in range(len(y)+1):
        D[0][i] = 0

    # Fill in the rest of the matrix
    for i in range(1, len(x)+1):
        for j in range(1, len(y)+1):
            distHor = D[i][j-1] + 1
            distVer = D[i-1][j] + 1
            if x[i-1] == y[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + 1
            D[i][j] = min(distHor, distVer, distDiag)

    # Edit distance is the value in the bottom right corner of the matrix
    return min( D[ len(D)-1 ] )

# test case
P = 'GCGTATGC'
T = 'TATTGGCTATACGGTT'
editDistance(P,T)
# 2

t = readGenome('chr1.GRCh38.excerpt.fasta')
p1 = 'GCTGATCGATCGTACG'
p2 = 'GATTTACCAGATTGAG'
editDistance(p1,t)
# 3
editDistance(p2,t)
# 2

# PROBLEMS 3 and 4 -------------------------------------------------------

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

def overlap_all_pairs(reads,k):
    # make sets of k-mers of each read, store as dictionary
    if k >= reads[0]:
        return 0
    sets = {}
    results = []
    for read in reads:
        read_length = len(read)
        loops = read_length - k
        read_set = set()
        for x in range(0,loops):
            kmer = read[x:x+k]
            read_set.add(kmer)
        sets[read] = set(read_set)
    # call overlap
    for a in reads:
        for b in reads:
            if a != b:
                if a[-k:] in sets[b]:
                    if overlap(a, b, k) > 0:
                        yes = (a,b)
                        results.append( yes )
    return results

# test cases
reads = ['ABCDEFG', 'EFGHIJ', 'HIJABC']
overlap_all_pairs(reads, 3)
overlap_all_pairs(reads, 4)

reads = ['CGTACG', 'TACGTA', 'GTACGT', 'ACGTAC', 'GTACGA', 'TACGAT']
overlap_all_pairs(reads, 4)
overlap_all_pairs(reads, 5)

# problem
s = readFastq('ERR266411_1.for_asm.fastq')
reads = s[0]
edges = overlap_all_pairs(reads, 30)
len(edges)
# 904746

nodes_s = set()
nodes_p = set()
for b in range(0, len(edges) ):
    nodes_s.add(edges[b][0])
    nodes_p.add(edges[b][1])
len(nodes_s)
# 7161
len(nodes_p)
# 8981
len( nodes_s | nodes_p )
# 9750
