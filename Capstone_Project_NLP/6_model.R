# load libraries 
library(data.table)
library(stylo)

# load ngram tables
load("ngrams_limit.Rdata")

# FUNCTION katz back-off n-gram with highest freqency model
text_predict <- function(text){
          # remove puntuation, convert to lowercase, and split into words
          text_split <- txt.to.words.ext(text, language="English.contr", preserve.case = FALSE)
          # replace contraction symbol 
          text_split_edit <- gsub("\\^", "'", text_split)
          # only use last 5 words if text is more than 5 words
          size <- length(text_split_edit)
          if (size >= 5) t <- text_split_edit[(size-4):size]
          if (size < 5) t <- text_split_edit 
          # katz back-off method, ngram-6
          if (size >= 5) {
                    prediction_6 <- n_6[J(t[1],t[2],t[3],t[4],t[5])][order(-N)][,6:7, with=FALSE]
                    prediction_5 <- n_5[J(t[2],t[3],t[4],t[5])][order(-N)][,5:6, with=FALSE]
                    prediction_4 <- n_4[J(t[3],t[4],t[5])][order(-N)][,4:5, with=FALSE]
                    prediction_3 <- n_3[J(t[4],t[5])][order(-N)][,3:4, with=FALSE]
                    prediction_2 <- n_2[J(t[5])][order(-N)][,2:3, with=FALSE]
                    prediction_6$P <- prediction_6$N / sum(prediction_6$N); setnames(prediction_6, c("WORD", "N","P"))                    
                    prediction_5$P <- prediction_5$N / sum(prediction_5$N); setnames(prediction_5, c("WORD", "N","P"))
                    prediction_4$P <- prediction_4$N / sum(prediction_4$N); setnames(prediction_4, c("WORD", "N","P"))
                    prediction_3$P <- prediction_3$N / sum(prediction_3$N); setnames(prediction_3, c("WORD", "N","P"))
                    prediction_2$P <- prediction_2$N / sum(prediction_2$N); setnames(prediction_2, c("WORD", "N","P"))                                   
                    prediction_all <- rbind(prediction_6, prediction_5, prediction_4, prediction_3, prediction_2, n_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
                    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
                    # katz back-off method, ngram-5
          } else if (size == 4) {
                    prediction_5 <- n_5[J(t[1],t[2],t[3],t[4])][order(-N)][,5:6, with=FALSE]
                    prediction_4 <- n_4[J(t[2],t[3],t[4])][order(-N)][,4:5, with=FALSE]
                    prediction_3 <- n_3[J(t[3],t[4])][order(-N)][,3:4, with=FALSE]
                    prediction_2 <- n_2[J(t[4])][order(-N)][,2:3, with=FALSE]
                    prediction_5$P <- prediction_5$N / sum(prediction_5$N); setnames(prediction_5, c("WORD", "N","P"))
                    prediction_4$P <- prediction_4$N / sum(prediction_4$N); setnames(prediction_4, c("WORD", "N","P"))
                    prediction_3$P <- prediction_3$N / sum(prediction_3$N); setnames(prediction_3, c("WORD", "N","P"))
                    prediction_2$P <- prediction_2$N / sum(prediction_2$N); setnames(prediction_2, c("WORD", "N","P"))                                   
                    prediction_all <- rbind(prediction_5, prediction_4, prediction_3, prediction_2, n_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
                    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
                    # katz back-off method, ngram-4
          } else if (size == 3) {
                    prediction_4 <- n_4[J(t[1],t[2],t[3])][order(-N)][,4:5, with=FALSE]
                    prediction_3 <- n_3[J(t[2],t[3])][order(-N)][,3:4, with=FALSE]
                    prediction_2 <- n_2[J(t[3])][order(-N)][,2:3, with=FALSE]
                    prediction_4$P <- prediction_4$N / sum(prediction_4$N); setnames(prediction_4, c("WORD", "N","P"))
                    prediction_3$P <- prediction_3$N / sum(prediction_3$N); setnames(prediction_3, c("WORD", "N","P"))
                    prediction_2$P <- prediction_2$N / sum(prediction_2$N); setnames(prediction_2, c("WORD", "N","P"))                                   
                    prediction_all <- rbind(prediction_4, prediction_3, prediction_2, n_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
                    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
                    # katz back-off method, ngram-3
          } else if (size == 2) {
                    prediction_3 <- n_3[J(t[1],t[2])][order(-N)][,3:4, with=FALSE]
                    prediction_2 <- n_2[J(t[2])][order(-N)][,2:3, with=FALSE]
                    prediction_3$P <- prediction_3$N / sum(prediction_3$N); setnames(prediction_3, c("WORD", "N","P"))
                    prediction_2$P <- prediction_2$N / sum(prediction_2$N); setnames(prediction_2, c("WORD", "N","P"))                                   
                    prediction_all <- rbind(prediction_3, prediction_2, n_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
                    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
                    # katz back-off method, ngram-2
          } else {
                    prediction_2 <- n_2[J(t[1])][order(-N)][,2:3, with=FALSE]
                    prediction_2$P <- prediction_2$N / sum(prediction_2$N); setnames(prediction_2, c("WORD", "N","P"))                                   
                    prediction_all <- rbind(prediction_2, n_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
                    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
          }
          # if no matches, use general top 100 ngram-1 
          if (is.na( prediction[1]$WORD )) {
                    prediction <- n_1[order(-P)]
          }
          # remove NA rows 
          prediction <- prediction[complete.cases(prediction),]
          # return data.table with best matches
          return(prediction)
}

# FUNCTION return text input filtered
text_return <- function(text){
          # remove puntuation, convert to lowercase, and split into words
          text_split <- txt.to.words.ext(text, language="English.contr", preserve.case = FALSE)
          # replace contraction symbol 
          text_split_edit <- gsub("\\^", "'", text_split)
          # profanity filter
          profanity <- "###"
          profanity_index <- grep(profanity, text_split_edit)
          text_split_edit[profanity_index] <-"PROFANITY_WORD"
          text_r <- paste(text_split_edit, sep="", collapse=" ")
          # return input filtered 
          return(text_r)
}

