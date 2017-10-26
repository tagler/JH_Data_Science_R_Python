# given functions:

def naive(p, t):
    occurrences = []
    for i in range(len(t) - len(p) + 1):  # loop over alignments
        match = True
        for j in range(len(p)):  # loop over characters
            if t[i+j] != p[j]:  # compare characters
                match = False
                break
        if match:
            occurrences.append(i)  # all chars matched; record
    return occurrences

def reverseComplement(s):
    complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'N': 'N'}
    t = ''
    for base in s:
        t = complement[base] + t
    return t

def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            # ignore header line with genome information
            if not line[0] == '>':
                genome += line.rstrip()
    return genome

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

# user functions: 

def naive_with_rc(p, t):
    r = reverseComplement(p)    
    if r == p:
        return naive(p,t)
    else:
        return naive(p,t)+naive(r,t)

g = readGenome('lambda_virus.fa')
seq = 'AGTCGA'
len( naive_with_rc(seq, g) )
min( naive_with_rc(seq, g) )

# test cases
naive_with_rc('ACTACT', g)
naive('ACTACT', g)
naive_with_rc('AACGTT', g)
naive('AACGTT', g)

def naive_2mm(p, t):
    occurrences = []
    for i in range(len(t) - len(p) + 1):  # loop over alignments
        match = True
        errors = 0
        for j in range(len(p)):  # loop over characters
            if t[i+j] != p[j]:  # compare characters
                errors = errors + 1
                if errors > 2:          
                    match = False
                    break
        if match:
            occurrences.append(i)  # all chars matched; record
    return occurrences
    
# test cases
naive_2mm( 'ACTTTA', 'ACTTACTTGATAAAGT')

seq = 'TTCAAGCC'
g = readGenome('lambda_virus.fa')

len( naive_2mm(seq, g) )
len( naive(seq, g) )

seq = 'AGGAGGTT'
min( naive_2mm(seq, g) )

z = readFastq('ERR037900_1.first1000.fastq')
z_genome = z[0]
z_qualities = z[1]

# list to store sum of q-scores
values = [0] * len( z_qualities[0] )
# loop q lines, 0-999
for x in range(0, len( z_qualities ) ):
    # loop through line, 0-99
    for y in range(0, len( z_qualities[0] ) ):
        char_value = ord( z_qualities[x][y] )
        values[y] = values[y] + char_value
        
min(values)
values.index(min(values))

