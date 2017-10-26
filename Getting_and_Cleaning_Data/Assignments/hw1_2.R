## library(xlsx) ## requires java
## library(XLConnect) ## requires java
## read.xlsx function
## read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE, colIndex, rowIndex)
## colIndex <- 2:3
## rowIndex <- 1:4

library(gdata)

data <- read.xls("./getdata-data-DATA.gov_NGAP.xls",sheet=1,)
dat <- data[16:20,7:15]

dat_1 <- as.numeric(as.character(dat[,1]))
dat_2 <- as.numeric(as.character(dat[,6]))

sum(dat_1*dat_2,na.rm=T)