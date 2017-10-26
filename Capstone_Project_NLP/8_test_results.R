library(stylo)
library(data.table)
library(splitstackshape)

# load data
load("test_sample.Rdata")

# sample test data 
samples <- 2500
all_sample <- all[sample(nrow(all), samples), ]

# prediction vectors
predictions_1 <- NA
predictions_2 <- NA
predictions_3 <- NA
predictions_4 <- NA
predictions_5 <- NA
predictions_6 <- NA
predictions_7 <- NA
predictions_8 <- NA
predictions_9 <- NA
predictions_10 <- NA

# loop to run model 
for (i in 1:samples) {
          temp <- text_predict( all_sample[i]$test )
          predictions_1 <- c(predictions_1, temp[1]$WORD )
          predictions_2 <- c(predictions_2, temp[2]$WORD )
          predictions_3 <- c(predictions_3, temp[3]$WORD )
          predictions_4 <- c(predictions_4, temp[4]$WORD )
          predictions_5 <- c(predictions_5, temp[5]$WORD )
          predictions_6 <- c(predictions_6, temp[6]$WORD )
          predictions_7 <- c(predictions_7, temp[7]$WORD )
          predictions_8 <- c(predictions_8, temp[8]$WORD )
          predictions_9 <- c(predictions_9, temp[9]$WORD )
          predictions_10 <- c(predictions_10, temp[10]$WORD )
}

# remove NA value 
predictions_1  <- predictions_1[2:(samples+1)]
predictions_2  <- predictions_2[2:(samples+1)]
predictions_3  <- predictions_3[2:(samples+1)]
predictions_4  <- predictions_4[2:(samples+1)]
predictions_5  <- predictions_5[2:(samples+1)]
predictions_6  <- predictions_6[2:(samples+1)]
predictions_7  <- predictions_7[2:(samples+1)]
predictions_8  <- predictions_8[2:(samples+1)]
predictions_9  <- predictions_9[2:(samples+1)]
predictions_10 <- predictions_10[2:(samples+1)]

# combine predictions 
final <- cbind(all_sample, predictions_1, predictions_2, predictions_3, predictions_4, predictions_5,
               predictions_6, predictions_7, predictions_8, predictions_9, predictions_10)

# correct matches with X words
correct_1  <- nrow(final[answer == predictions_1 ])
correct_2  <- nrow(final[answer == predictions_1 | answer == predictions_2 ])
correct_3  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 ])
correct_4  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 ])
correct_5  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 ])
correct_6  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 | answer == predictions_6 ])
correct_7  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 | answer == predictions_6 | answer == predictions_7 ])
correct_8  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 | answer == predictions_6 | answer == predictions_7 | answer == predictions_8 ])
correct_9  <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 | answer == predictions_6 | answer == predictions_7 | answer == predictions_8 | answer == predictions_9 ])
correct_10 <- nrow(final[answer == predictions_1 | answer == predictions_2 | answer == predictions_3 | answer == predictions_4 | answer == predictions_5 | answer == predictions_6 | answer == predictions_7 | answer == predictions_8 | answer == predictions_9 | answer == predictions_10 ])

# results
n = c(1,2,3,4,5,6,7,8,9,10)
correct <- c(correct_1, correct_2, correct_3, correct_4, correct_5, correct_6, correct_7, correct_8, correct_9, correct_10) 
sample_size <- c(samples, samples, samples, samples, samples, samples, samples, samples, samples, samples)
accuracy <- correct/sample_size
df <- data.frame(n, correct, sample_size, accuracy)

# base model, use 10 most frequent words
base_words <- base$WORD

# correct matches for base model
base_1  <- nrow(final[answer == base_words[1] ])
base_2  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] ])
base_3  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] ])
base_4  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] ])
base_5  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] ])
base_6  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] | answer ==  base_words[6] ])
base_7  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] | answer ==  base_words[6] | answer ==  base_words[7] ])
base_8  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] | answer ==  base_words[6] | answer ==  base_words[7] | answer ==  base_words[8] ])
base_9  <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] | answer ==  base_words[6] | answer ==  base_words[7] | answer ==  base_words[8] | answer ==  base_words[9] ])
base_10 <- nrow(final[answer == base_words[1] | answer ==  base_words[2] | answer ==  base_words[3] | answer ==  base_words[4] | answer ==  base_words[5] | answer ==  base_words[6] | answer ==  base_words[7] | answer ==  base_words[8] | answer ==  base_words[9] | answer ==  base_words[10] ])

# base model results
base_correct <- c(base_1, base_2, base_3, base_4, base_5, base_6, base_7, base_8, base_9, base_10) 
base_accuracy <- base_correct/sample_size
df_base <- data.frame(n, base_correct, sample_size, base_accuracy)

# repeat above code 5 times...
# df_1 <- df # df_2 <- df # df_3 <- df # df_4 <- df # df_5 <- df
# df_base_1 <- df_base # df_base_2 <- df_base # df_base_3 <- df_base # df_base_4 <- df_base # df_base_5 <- df_base

# combine data frames
df_model <- rbind(df_1, df_2, df_3, df_4, df_5)
df_base  <- rbind(df_base_1, df_base_2, df_base_3, df_base_4, df_base_5)

# save
save(df_model, df_base, file="test.results.Rdata")
