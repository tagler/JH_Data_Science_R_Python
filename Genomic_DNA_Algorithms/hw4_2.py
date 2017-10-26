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

t = readFastq('ads1_week4_reads.fq')
seq = t[0]

all_words = seq
all_N = len(all_words)

words = []

# remove strings which are substrings of others
for i in xrange(all_N):
    for j in xrange(all_N):
        if i != j and all_words[i] != all_words[j] and all_words[i] in all_words[j]:
            break
    else:
        words.append(all_words[i])

N = len(words)


# determine the numerical overlap between two strings a,b
def overlap(a, b):
    best = 0
    for i in xrange(1, min(len(a), len(b))+1):
        if b.startswith(a[-i:]):
            best = i
    return best


cost = [[None] * N for _ in xrange(N)]
# Precompute edge costs
# for every pair of words with indices u,v
for u in xrange(N):
    for v in xrange(N):
        # work out the best compressed concatenation you can make with u then v
        cost[u][v] = len(words[u]) + len(words[v]) - overlap(words[u], words[v])


cache = {}
backtrace = {}

# top-down DP
def solve(used, last):
    if (used,last) not in cache:

        bestCost = 0
        bestOption = None

        # the base case is when used == 0. using no words, the optimal solution is of length 0
        if used != 0:

            bestCost = float('inf')

            # for each word we can use
            for i in xrange(N):

                # if the word is as yet unused
                if (1 << i) & used:

                    # calc the cost of using it
                    newCost = cost[i][last] + solve(used & ~(1<<i), i)

                    # if we've reached a new best solution, update stuff
                    if newCost < bestCost:
                        bestCost = newCost
                        bestOption = i

        # cache stuff
        cache[(used, last)] = bestCost
        backtrace[(used, last)] = bestOption

    return cache[(used, last)]


# run it for all possible starting cases
bestCost = float('inf')
bestOption = None
for i in xrange(N):
    cur = solve(((1<<N)-1) & ~(1<<i), i)
    if cur < bestCost:
        bestCost = cur
        bestOption = i


# reconstruct the words that were used
soln = []
used = (1<<N) - 1
last = bestOption
while last is not None:
    soln.append(words[last])
    used &= ~(1<<last)
    last = backtrace[(used, last)]
soln.reverse()


# now compress the words of the solution into the final string
cur = soln[0]
for i in xrange(1, N):
    cur += soln[i][overlap(cur, soln[i]):]
print cur
