## ================================================================================
## PROJECT - UCI HAR Dataset - ANALYSIS R SCRIPT ==================================
## ================================================================================

## Data for this project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## NOTE: extract UCI HAR Dataset zip file to ./UCI HAR Dataset/

## load plyr library - tools for splitting, applying and combining data
library(plyr)

## --------------------------------------------------------------------------------
## read raw data into R -----------------------------------------------------------
## --------------------------------------------------------------------------------

## read activity labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              col.names = c("Activity.Number","Activity.Name"))

## read feature column labels 
feature_labels <- read.table("./UCI HAR Dataset/features.txt",
                             colClasses = "character")
## remove first column containing numbers, will use as column names
feature_labels_2 <- feature_labels[,2]

## read feature data
feature_test_data <- read.table("./UCI HAR Dataset/test/X_test.txt",
                                col.names = feature_labels_2)
feature_train_data <- read.table("./UCI HAR Dataset/train/X_train.txt",
                                 col.names = feature_labels_2)

## read subjet number data, as factors
subject_test_data <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                                col.names = "Subject.Number",
                                colClasses = "factor")
subject_train_data <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                                 col.names = "Subject.Number",
                                 colClasses = "factor")

## read activity number data
activity_test_data <- read.table("./UCI HAR Dataset/test/y_test.txt",
                                 col.names = "Activity.Number")
activity_train_data <- read.table("./UCI HAR Dataset/train/y_train.txt",
                                  col.names = "Activity.Number")

## --------------------------------------------------------------------------------
## select and organize data -------------------------------------------------------
## --------------------------------------------------------------------------------

## select only data that is a "mean" or "std" anywhere in the name of feature
feature_test_meanstd <- feature_test_data[ , grepl("mean|std", 
                                              names(feature_test_data),
                                              ignore.case = TRUE)]
feature_train_meanstd <- feature_train_data[ , grepl("mean|std", 
                                              names(feature_train_data),
                                              ignore.case = TRUE)]

## combine activity data with label data and make new combined table
activity_test_data_combined <- join(activity_test_data,
                                  activity_labels,
                                  by='Activity.Number')
activity_train_data_combined <- join(activity_train_data,
                                  activity_labels,
                                  by='Activity.Number')

## remove number columns, keep only text columns, keep as data frame (drop=false)
activity_test_data_txt <- activity_test_data_combined[,2,
                                                      drop = FALSE]
activity_train_data_txt <- activity_train_data_combined[,2,
                                                        drop = FALSE]

## combine columns for each data set (subject + activity + feature)
test_data <- cbind(subject_test_data, 
                   activity_test_data_txt, 
                   feature_test_meanstd)
train_data <- cbind(subject_train_data, 
                   activity_train_data_txt, 
                   feature_train_meanstd)

## combine test and train data sets
tidy_dataset <- rbind(test_data, train_data)

## --------------------------------------------------------------------------------
## make column variable names "tidy" ----------------------------------------------
## --------------------------------------------------------------------------------

## full variables names were used from reference features.txt and readme.txt
names(tidy_dataset) <- 
     gsub("...", ".", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("..", ".", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("tBody", "Time.Domain.Signal.Body.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("fBody", "Frequency.Domain.Signals.Body.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("tGravity", "Time.Domain.Signal.Gravity.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("angle", "Angle.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("gravityMean", "Gravity.Mean.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("Acc", "Accelerometer.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("Gyro", "Gyroscope.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <- 
     gsub("Jerk", "Jerk.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("Mag", "Magnitude", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("mean", "Mean", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("std", "Standard.Deviation", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("MeanFreq", "Mean.Frequency.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("gravity", "Gravity", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("BodyGyroscope", "Gyroscope.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("BodyAccelerometer", "Accelerometer.", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub(".X", ".X.Axis", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub(".Y", ".Y.Axis", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub(".Z", ".Z.Axis", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("...", ".", names(tidy_dataset), fixed = TRUE)
names(tidy_dataset) <-
     gsub("..", ".", names(tidy_dataset), fixed = TRUE)

## --------------------------------------------------------------------------------
## find average for each activity for each subject --------------------------------
## --------------------------------------------------------------------------------

## find average of all features for each subject and each activity name
## 30 subjects * 6 different activities = 180 groups 
tidy_dataset_averages <- aggregate(tidy_dataset[3:88], 
                                   by=list("Subject.Number" = tidy_dataset$Subject.Number, 
                                           "Activity.Name" = tidy_dataset$Activity.Name), 
                                   FUN=mean)
## alternative method using ddply:
## tidy_dataset_averages <- ddply(tidy_dataset,
##                          c("Subject.Number", "Activity.Name"),
##                          colwise(mean))

## change column names to indiate average was taken
newnames <- paste(names(tidy_dataset_averages),"-Average", sep = ".")
newnames[1] <- "Subject.Number"
newnames[2] <- "Activity.Description"
colnames(tidy_dataset_averages) <- newnames 
names(tidy_dataset_averages) <-
     gsub(".-", "-", names(tidy_dataset_averages), fixed = TRUE)

## convert subject.number from factor to numeric, in order to sort numerically 
tidy_dataset_averages$Subject.Number <- as.numeric(as.character(
     tidy_dataset_averages$Subject.Number))

## sort data by subject number and then activity name 
tidy_dataset_averages_sort <- tidy_dataset_averages[
     order(tidy_dataset_averages$Subject.Number,
           tidy_dataset_averages$Activity.Description),]

## save to final tidy data set variable 
tidy_dataset_final <- tidy_dataset_averages_sort

## --------------------------------------------------------------------------------
## export  ------------------------------------------------------------------------
## --------------------------------------------------------------------------------

## export data
write.table(tidy_dataset_final, 
            file ="tidy-dataset-final-averages.txt", 
            row.name=FALSE) 