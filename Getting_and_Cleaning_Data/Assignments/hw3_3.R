## input data
data1 <- read.csv("getdata-data-GDP-2.csv", na.strings = "..", header = TRUE)
data2 <- read.csv("getdata-data-EDSTATS_Country.csv", na.strings = "")

## match based on countrycode, inner join
newdata <- join(data1,data2,by=c("CountryCode"), type="inner")

## remove , from numbers
x <-  as.numeric(gsub(",","", newdata$Gross.domestic.product.2012))
newdata$Gross.domestic.product.2012 <- x

## order decreasing based on GDP
newnew <- newdata[order(newdata$Gross.domestic.product.2012,decreasing = FALSE),]

## take average of rankings of income.group
library(plyr)
tidy_dataset_averages <- ddply(newnew, .(Income.Group), summarize,
                          mean=mean(Ranking))

library(Hmisc)