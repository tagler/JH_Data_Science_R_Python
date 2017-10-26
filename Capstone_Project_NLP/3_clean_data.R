# load data
load("sample_data.Rdata")

# combine into single data set 
all_words <- c(b_sample, n_sample, t_sample)

# label start / end of lines with unique tags not in data set
all_words_start <- paste("startoflinetag", all_words)
all_words_start_stop <- paste(all_words_start, "endoflinetag")

# tokenize into words using stylo package
library(stylo)
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

# save datagrep
save(all_words_pc, file="clean_data.Rdata")
