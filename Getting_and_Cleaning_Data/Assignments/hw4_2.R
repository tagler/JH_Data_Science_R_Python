x <- read.csv("getdata-data-GDP.csv")
y <- gsub(",","",x$X.3)
y <- as.numeric(y[1:200])
mean(y, na.rm = TRUE)

countryNames <- x$X.2
grep("^United",countryNames)

xx <- read.csv("getdata-data-EDSTATS_Country.csv")
xx2 <- x[5:194,]
colnames(xx2)[4] <- "Short.Name"

data <- merge(xx,xx2,by="Short.Name")

length(grep("end: june",data$Special.Notes, ignore.case=TRUE))
