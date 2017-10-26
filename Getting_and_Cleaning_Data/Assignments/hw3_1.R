data <- read.csv("getdata-data-ss06hid.csv")
agricultureLogical <- data[which(data$AGS == 6 & data$ACR == 3),]