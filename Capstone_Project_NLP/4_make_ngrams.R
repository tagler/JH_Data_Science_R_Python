# load libraries 
library(stylo)
library(data.table)

# load data
load("clean_data.Rdata")

# make n-grams, start with 6-grams
ngram_6 <- make.ngrams(all_words_pc, ngram.size = 6)

# convert to data.table objects for faster processing 
ngram_6_table <- data.table(ngram_6)

# save data
save(ngram_6_table, file="ngram_table.Rdata")