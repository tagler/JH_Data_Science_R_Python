library(ggplot2)

#load acuracy data
load("test.results.Rdata")

# format data
colnames(df_model) <- c("words", "n_correct", "n_total", "accuracy")
colnames(df_base) <- c("words", "n_correct", "n_total", "accuracy")
df_model$type <- "perdiction"
df_base$type <- "base"
data_all <- rbind(df_model, df_base)
data_all$n_correct <- NULL
data_all$n_total <- NULL
data <- data_all

# plot
ggplot(data, aes(x=words, y=(accuracy*100), color=type)) +
          geom_point(alpha = 1, size = 2) +
          labs(x = " \n Number of Word Predictions, n") +
          labs(y = "Prediction Accuracy, % \n") +
          scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
          scale_y_continuous(breaks=c(0,5,10,15,20,25,30,35,40)) +
          geom_smooth(method = "loess", size = 0.5) +
          scale_color_manual("Models:", labels = c("Baseline Model", "Text-Prediction App"), 
                             values = c("firebrick3", "dodgerblue3")) +
          theme_grey(base_size = 22) 

# format data
means <- with(data, tapply(accuracy, list(words, type), mean))
sds <- with(data, tapply(accuracy, list(words, type), sd))
words <- c(1,2,3,4,5,6,7,8,9,10)
prediction_model <- as.data.frame(words)
base_model <- as.data.frame(words)
prediction_model$accuracy_mean <- means[,2]
base_model$accuracy_mean <- means[,1]
prediction_model$sd <- sds[,2]
base_model$sd <- sds[,1]
prediction_model$type <- "prediction"
base_model$type <- "base"
data_2 <- rbind(prediction_model, base_model)

# plot 2
ggplot(data_2, aes(x=words, y=(accuracy_mean*100), color=type)) +
          geom_point(alpha = 1, size = 3) +
          geom_errorbar(aes(ymin=(accuracy_mean-sd)*100, ymax=(accuracy_mean+sd)*100), width=.15) +
          labs(x = " \n Number of Word Predictions, n") +
          labs(y = "Prediction Accuracy (\u03BC \U00b1 1\u03C3), % \n") +
          scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
          scale_y_continuous(breaks=c(0,5,10,15,20,25,30,35,40)) +
          geom_smooth(method = "loess", size = 0.5) +
          scale_color_manual("Models:", labels = c("Baseline Model", "Text-Prediction App"), 
                             values = c("firebrick3", "dodgerblue3")) +
          theme_grey(base_size = 22) 
