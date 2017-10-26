# load libraries 
library(data.table)
library(splitstackshape)

# load data
load("ngram_table.Rdata")

# seperate string into word columns 
ng_6 <- cSplit_f(ngram_6_table, "ngram_6", " ")
setnames(ng_6,1:6,c("n1","n2","n3","n4","n5","n6"))

# make 1-grams, 2-grams, 3-grams, 4-grams, and 5-grams from 6-grams data.table
ng_1 <- ng_6[,1, with=FALSE]
ng_2 <- ng_6[,1:2, with=FALSE]
ng_3 <- ng_6[,1:3, with=FALSE]
ng_4 <- ng_6[,1:4, with=FALSE]
ng_5 <- ng_6[,1:5, with=FALSE]

# remove grams with START_LINE and END_LINE tags 
ng_1_ss <- ng_1[ n1 != 'START_STOP_TAG' ] 
ng_2_ss <- ng_2[ n1 != 'START_STOP_TAG' & n2 != 'START_STOP_TAG' ] 
ng_3_ss <- ng_3[ n1 != 'START_STOP_TAG' & n2 != 'START_STOP_TAG' & n3 != 'START_STOP_TAG' ] 
ng_4_ss <- ng_4[ n1 != 'START_STOP_TAG' & n2 != 'START_STOP_TAG' & n3 != 'START_STOP_TAG' & n4 != 'START_STOP_TAG' ]
ng_5_ss <- ng_5[ n1 != 'START_STOP_TAG' & n2 != 'START_STOP_TAG' & n3 != 'START_STOP_TAG' & n4 != 'START_STOP_TAG' & n5 != 'START_STOP_TAG' ] 
ng_6_ss <- ng_6[ n1 != 'START_STOP_TAG' & n2 != 'START_STOP_TAG' & n3 != 'START_STOP_TAG' & n4 != 'START_STOP_TAG' & n5 != 'START_STOP_TAG' & n6 != 'START_STOP_TAG' ] 

# create freqency tables 
ngram_1_freq <- ng_1_ss[, .N ,by = list(n1)]
ngram_2_freq <- ng_2_ss[, .N ,by = list(n1,n2)]
ngram_3_freq <- ng_3_ss[, .N ,by = list(n1,n2,n3)]
ngram_4_freq <- ng_4_ss[, .N ,by = list(n1,n2,n3,n4)]
ngram_5_freq <- ng_5_ss[, .N ,by = list(n1,n2,n3,n4,n5)]
ngram_6_freq <- ng_6_ss[, .N ,by = list(n1,n2,n3,n4,n5,n6)]

# filted out low-freq values
n_1 <- ngram_1_freq[ N > 1 ]
n_2 <- ngram_2_freq[ N > 1 ]
n_3 <- ngram_3_freq[ N > 1 ]
n_4 <- ngram_4_freq[ N > 1 ]
n_5 <- ngram_5_freq[ N > 1 ]
n_6 <- ngram_6_freq[ N > 1 ]

# ngram-1 table, top 100 single words
setkey(n_1,n1)
n_1$P <- n_1$N / sum(n_1$N)
setnames(n_1, c("WORD", "N","P"))
n_1 <- n_1[order(-N)][1:100]

# key and sort data.tables for fast lookup
setkey(n_1,WORD)
setkey(n_2,n1,n2)
setkey(n_3,n1,n2,n3)
setkey(n_4,n1,n2,n3,n4)
setkey(n_5,n1,n2,n3,n4,n5)
setkey(n_6,n1,n2,n3,n4,n5,n6)

# save ngram tables
save(n_1, n_2, n_3, n_4, n_5, n_6, file="ngrams_limit.Rdata")
