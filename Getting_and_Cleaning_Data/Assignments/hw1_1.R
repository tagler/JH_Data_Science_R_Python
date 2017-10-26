## create data dir
if (!file.exists("data")) {
     dir.create("data")
}

## download data and store in data1.csv
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
                       destfile="./data/data1.csv",
                       method="curl")

## read csv data from data1.csv and store in data variable 
data <- read.csv("./data/data1.csv")

# counts number of samples in each VAL group
x <- table(data$VAL)
x[24]