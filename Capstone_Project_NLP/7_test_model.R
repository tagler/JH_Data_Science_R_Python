library(stylo)
library(data.table)
library(splitstackshape)

# load data - 100k randomly sampled lines
load("raw_data.Rdata")
b_test <- sample(blogs, 20000)
n_test <- sample(news, 20000)
t_test <- sample(twitter, 60000)

# combine into single data set
all_words <- c(b_test, n_test, t_test)

# label start / end of lines with unique tags not in data set
all_words_start <- paste("startoflinetag", all_words)
all_words_start_stop <- paste(all_words_start, "endoflinetag")

# tokenize into words using stylo package
all_words_ss <- txt.to.words.ext(all_words_start_stop, language="English.contr", preserve.case = FALSE)

# re-label start / stop tags
all_words_ss_start <- gsub("startoflinetag", "START_STOP_TAG", all_words_ss)
all_words_ss_start_stop <- gsub("endoflinetag", "START_STOP_TAG", all_words_ss_start)

# basic profanity filter
all_words_p <- all_words_ss_start_stop
profanity <- "###"
profanity_index <- grep(profanity, all_words_ss_start_stop)
all_words_p[profanity_index] <-"PROFANITY_WORD"

# replace contraction ^ symbol with '
all_words_pc <- gsub("\\^", "'", all_words_p)

# make n-grams, start with 6-grams
ngram_6 <- make.ngrams(all_words_pc, ngram.size = 6)

# convert to data.table objects for faster processing
ngram_6_table <- data.table(ngram_6)

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

# combine words
ng_2_ss$test <- ng_2_ss$n1
ng_2_ss$answer <- ng_2_ss$n2
ng_3_ss$test <- with(ng_3_ss, paste(n1, n2, sep = " "))
ng_3_ss$answer <- ng_3_ss$n3
ng_4_ss$test <- with(ng_4_ss, paste(n1, n2, n3, sep = " "))
ng_4_ss$answer <- ng_4_ss$n4
ng_5_ss$test <- with(ng_5_ss, paste(n1, n2, n3, n4, sep = " "))
ng_5_ss$answer <- ng_5_ss$n5
ng_6_ss$test <- with(ng_6_ss, paste(n1, n2, n3, n4, n5, sep = " "))
ng_6_ss$answer <- ng_6_ss$n6

# take only important columns
n2 <- ng_2_ss[,3:4,with=FALSE]
n3 <- ng_3_ss[,4:5,with=FALSE]
n4 <- ng_4_ss[,5:6,with=FALSE]
n5 <- ng_5_ss[,6:7,with=FALSE]
n6 <- ng_6_ss[,7:8,with=FALSE]

# base model - most frequent 1-grams
ngram_1_freq <- ng_1_ss[, .N ,by = list(n1)]
n_1 <- ngram_1_freq[ N > 1 ]
n_1$P <- n_1$N / sum(n_1$N)
setnames(n_1, c("WORD", "N","P"))
base <- n_1[order(-N)][1:10]

# combine
all <- rbind(n2,n3,n4,n5,n6)

# save test data
save(all, base, file='test_sample.Rdata')
