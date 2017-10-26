## import xml file from web
library(XML)
fileurl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileurl,useInternal=TRUE)
rootNode <- xmlRoot(doc)

## read all values
xmlSApply(rootNode,xmlValue)

## print out all zip code values
z <- xpathSApply(rootNode,"//zipcode",xmlValue)
## count number of each zip code
y <- table(z)
## number in 21231 zip code
y["21231"]
