## Cleaning Data - Human Activity Recognition Data   

### DATA

Data for this project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

### FILES

README.md = overview of files and project

human-activity-recognition.R = script that produces the tidy data set from raw data set

human-activity-recognition-codebook.md = contains detailed information on data, variables, labels, transformations

NOTE: extract the UCI HAR Dataset zip file to ./UCI HAR Dataset/ directory

## DESCRIPTION

1. Import subject, activity, and feature data from UCI HAR dataset

2. Add descriptive variable names to each column

3. Subset only measurements on the mean and standard deviation (defined as either “mean” or “std” in the variable name)

4. Convert activity numbers to descriptive activity names (TIDY DATA)

5. Combine the test and training data sets into a single tidy dataset

6. Calculate the AVERAGE of each variable for each unique group of subject and activity (30 subjects with 6 activities each = 180 unique groups)

7. Output final results to the "tidy-dataset-final-averages.txt" file
