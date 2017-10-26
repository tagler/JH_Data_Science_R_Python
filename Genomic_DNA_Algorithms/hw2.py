# problems 1-2 ---------------------------------------------------------------------

def naive_with_counts(p, t):
    occurrences = []
    mum_alignments = 0
    num_character_comparisons = 0
    for i in range(len(t) - len(p) + 1):  # loop over alignments
        mum_alignments += 1
        match = True
        for j in range(len(p)):  # loop over characters
            num_character_comparisons += 1
            if t[i+j] != p[j]:  # compare characters
                match = False
                break
        if match:
            occurrences.append(i)  # all chars matched; record
    return occurrences, mum_alignments, num_character_comparisons

# test cases
p = 'word'
t = 'there would have been a time for such a word'
naive_with_counts(p, t)
p = 'needle'
t = 'needle need noodle needle'
naive_with_counts(p, t)

p = 'GGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGG'
t = readGenome('chr1.GRCh38.excerpt.fasta')
naive_with_counts(p, t)
# ([56922], 799954, 984143)

# problem 3 -----------------------------------------------------------------------

def boyer_moore_with_counts(p, p_bm, t):
    """ Do Boyer-Moore matching. p=pattern, t=text,
        p_bm=BoyerMoore object for p """
    i = 0
    occurrences = []
    mum_alignments = 0
    num_character_comparisons = 0
    while i < len(t) - len(p) + 1:
        shift = 1
        mismatched = False
        mum_alignments += 1
        for j in range(len(p)-1, -1, -1):
            num_character_comparisons += 1
            if p[j] != t[i+j]:
                skip_bc = p_bm.bad_character_rule(j, t[i+j])
                skip_gs = p_bm.good_suffix_rule(j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = True
                break
        if not mismatched:
            occurrences.append(i)
            skip_gs = p_bm.match_skip()
            shift = max(shift, skip_gs)
        i += shift
    return occurrences, mum_alignments, num_character_comparisons

# test cases
p = 'word'
t = 'there would have been a time for such a word'
lowercase_alphabet = 'abcdefghijklmnopqrstuvwxyz '
p_bm = BoyerMoore(p, lowercase_alphabet)
boyer_moore_with_counts(p, p_bm, t)
p = 'needle'
t = 'needle need noodle needle'
p_bm = BoyerMoore(p, lowercase_alphabet)
boyer_moore_with_counts(p, p_bm, t)

p = 'GGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGG'
t = readGenome('chr1.GRCh38.excerpt.fasta')
lowercase_alphabet = 'ACGT'
p_bm = BoyerMoore(p, lowercase_alphabet)
boyer_moore_with_counts(p, p_bm, t)
#  ([56922], 127974, 165191)

# problems 4 and 5 -------------------------------------------------------------------------

import bisect

class Index(object):
    def __init__(self, t, k):
        ''' Create index from all substrings of size 'length' '''
        self.k = k  # k-mer length (k)
        self.index = []
        for i in range(len(t) - k + 1):  # for each k-mer
            self.index.append((t[i:i+k], i))  # add (k-mer, offset) pair
        self.index.sort()  # alphabetize by k-mer

    def query(self, p):
        ''' Return index hits for first k-mer of P '''
        kmer = p[:self.k]  # query with first k-mer
        i = bisect.bisect_left(self.index, (kmer, -1))  # binary search
        hits = []
        while i < len(self.index):  # collect matching index entries
            if self.index[i][0] != kmer:
                break
            hits.append(self.index[i][1])
            i += 1
        return hits

def approximate_match_index(p, t, n, index):
    segment_length = int(round(len(p) / (n+1)))
    all_matches = set()
    all_hits = []
    for i in range(n+1):
        start = i*segment_length
        end = min((i+1)*segment_length, len(p))
        matches = index.query(p[start:end])
        # Extend matching segments to see if whole p matches
        for m in matches:
            all_hits.append(m)
            if m < start or m-start+len(p) > len(t):
                continue
            mismatches = 0
            for j in range(0, start):
                if not p[j] == t[m-start+j]:
                    mismatches += 1
                    if mismatches > n:
                        break
            for j in range(end, len(p)):
                if not p[j] == t[m-start+j]:
                    mismatches += 1
                    if mismatches > n:
                        break
            if mismatches <= n:
                all_matches.add(m - start)
    return list(all_matches), all_hits

p = 'GGCGCGGTGGCTCACGCCTGTAAT'
t = readGenome('chr1.GRCh38.excerpt.fasta')
k = 8
n = 2
index = Index(t, k)

approximate_match_index(p, t, n, index)

len( approximate_match_index(p, t, n, index)[0] )
# 19
len( approximate_match_index(p, t, n, index)[1] )
# 90

# problem 6 ------------------------------------------------------------------------

import bisect

class SubseqIndex(object):
    """ Holds a subsequence index for a text T """

    def __init__(self, t, k, ival):
        """ Create index from all subsequences consisting of k characters
            spaced ival positions apart.  E.g., SubseqIndex("ATAT", 2, 2)
            extracts ("AA", 0) and ("TT", 1). """
        self.k = k  # num characters per subsequence extracted
        self.ival = ival  # space between them; 1=adjacent, 2=every other, etc
        self.index = []
        self.span = 1 + ival * (k - 1)
        for i in range(len(t) - self.span + 1):  # for each subseq
            self.index.append((t[i:i+self.span:ival], i))  # add (subseq, offset)
        self.index.sort()  # alphabetize by subseq

    def query(self, p):
        """ Return index hits for first subseq of p """
        subseq = p[:self.span:self.ival]  # query with first subseq
        i = bisect.bisect_left(self.index, (subseq, -1))  # binary search
        hits = []
        while i < len(self.index):  # collect matching index entries
            if self.index[i][0] != subseq:
                break
            hits.append(self.index[i][1])
            i += 1
        return hits

def query_subseq(p, t, n, ival, index):
    all_matches = set()
    all_hits = []
    for i in range(n+1):
        matches = index.query(p[i:])
        # Extend matching segments to see if whole p matches
        for m in matches:
            all_hits.append(m)
            if m < start or m-start+len(p) > len(t):
                continue
            mismatches = 0
            for j in range(0, start):
                if not p[j] == t[m-start+j]:
                    mismatches += 1
                    if mismatches > n:
                        break
            for j in range(end, len(p)):
                if not p[j] == t[m-start+j]:
                    mismatches += 1
                    if mismatches > n:
                        break
            if mismatches <= n:
                all_matches.add(m - start)
    return list(all_matches), all_hits

n = 2

t = 'to-morrow and to-morrow and to-morrow creeps in this petty pace'
p = 'to-morrow and to-morrow '
subseq_ind = SubseqIndex(t, 8, 3)
query_subseq(p, t, n, ival, subseq_ind)
len ( query_subseq(p, t, n, ival, subseq_ind)[0] )
len ( query_subseq(p, t, n, ival, subseq_ind)[1] )
# 22 and 79

# King John by William Shakespeare
import wget
!wget http://www.gutenberg.org/ebooks/1110.txt.utf-8
t = open('1110.txt.utf-8.txt').read()
p = 'English measure backward'
subseq_ind = SubseqIndex(t, 8, 3)
query_subseq(p, t, n, ival, subseq_ind)


p = 'GGCGCGGTGGCTCACGCCTGTAAT'
t = readGenome('chr1.GRCh38.excerpt.fasta')
subseq_ind = SubseqIndex(t, 8, 3)
query_subseq(p, t, n, ival, subseq_ind)
len ( query_subseq(p, t, n, ival, subseq_ind)[0] )
len ( query_subseq(p, t, n, ival, subseq_ind)[1] )

x = query_subseq(p, t, n, ival, subseq_ind)[0]



d = []
d.append([0]*9)
