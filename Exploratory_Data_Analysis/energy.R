## PLOT 1 ==============================================================================

## input data --------------------------------------------------------------------------

## define class of each column
colc=c("character","character",rep("numeric",7))

## define column titles (header will be lost due to skiped rows in read.table)
coln=c("Date","Time","Global_active_power","Global_reactive_power",
       "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
       "Sub_metering_3")

## read data from data file, only read Feb 1 and Feb 2, 2007 data (row 66636 to 69516)
data <- read.table("household_power_consumption.txt", 
                   header = TRUE, 
                   sep=";", 
                   na.strings = "?", 
                   skip = 66636,
                   nrows = 2880,
                   colClasses = colc,
                   col.names = coln)

## make plot -------------------------------------------------------------------------

## open new png graphics device
png("plot1.png")

## make histogram of global active power
hist(data$Global_active_power, 
     ## color
     col="red", 
     ## labels
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power",
     ## ranges of axes 
     xlim = c(0,8),
     ylim = c(0,1200),
     ## hide both axis, to allow remake at correct steps 
     axes = FALSE)

## add axes with correct steps
axis(side=1, at=c(0,2,4,6))
axis(side=2, at=c(0,200,400,600,800,1000,1200))

## finish graphic device plot
dev.off()

## PLOT 2 ==============================================================================

## input data --------------------------------------------------------------------------

## define class of each column
colc=c("character","character",rep("numeric",7))

## define column titles (header will be lost due to skiped rows in read.table)
coln=c("Date","Time","Global_active_power","Global_reactive_power",
       "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
       "Sub_metering_3")

## read data from data file, only read Feb 1 and Feb 2, 2007 data (row 66636 to 69516)
data <- read.table("household_power_consumption.txt", 
                   header = TRUE, 
                   sep=";", 
                   na.strings = "?", 
                   skip = 66636,
                   nrows = 2880,
                   colClasses = colc,
                   col.names = coln)

## make plot -------------------------------------------------------------------------

## convert date and time to datetime class object 
datetime <- paste(data$Date, data$Time)
datetimeobject <- strptime(datetime, 
                           format="%d/%m/%Y %H:%M:%S")

## add new datetime object back to data 
data$DateTime <- datetimeobject

## remove old date and time, and reorder new datetime object to first column  
data <- data[c(-1,-2)]
data <- data[c(8,1,2,3,4,5,6,7)]

## open new png graphics device
png("plot2.png")

# scatterplot date-time vs. global active power
plot(data$DateTime, data$Global_active_power,
     ## labels for plot
     main = "",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     ## line type: lines without points 
     type = "l")

## finish graphic device plot
dev.off()

## PLOT 3 ==============================================================================

## input data --------------------------------------------------------------------------

## define class of each column
colc=c("character","character",rep("numeric",7))

## define column titles (header will be lost due to skiped rows in read.table)
coln=c("Date","Time","Global_active_power","Global_reactive_power",
       "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
       "Sub_metering_3")

## read data from data file, only read Feb 1 and Feb 2, 2007 data (row 66636 to 69516)
data <- read.table("household_power_consumption.txt", 
                   header = TRUE, 
                   sep=";", 
                   na.strings = "?", 
                   skip = 66636,
                   nrows = 2880,
                   colClasses = colc,
                   col.names = coln)

## make plot -------------------------------------------------------------------------

## convert date and time to datetime class object 
datetime <- paste(data$Date, data$Time)
datetimeobject <- strptime(datetime, 
                           format="%d/%m/%Y %H:%M:%S")

## add new datetime object back to data 
data$DateTime <- datetimeobject

## remove old date and time, and reorder new datetime object to first column  
data <- data[c(-1,-2)]
data <- data[c(8,1,2,3,4,5,6,7)]

## open new png graphics device
png("plot3.png")

# scatterplot date-time vs. Energy sub_metering1,2,3
plot(data$DateTime, data$Sub_metering_1,
     ## labels for plot
     main = "",
     xlab = "",
     ylab = "Energy sub metering",
     ## color
     col = "black",
     ## line type: lines without points 
     type = "l")
points(data$DateTime, data$Sub_metering_2,
       ## color
       col = "red",
       ## line type: lines without points 
       type = "l")
points(data$DateTime, data$Sub_metering_3,
       ## color
       col = "blue",
       ## line type: lines without points 
       type = "l")

## add legend in top-right corner
legend("topright", 
       ## line, not point
       lty = 1,
       ## labels
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

## finish graphic device plot
dev.off()

## PLOT 4 ==============================================================================

## input data --------------------------------------------------------------------------

## define class of each column
colc=c("character","character",rep("numeric",7))

## define column titles (header will be lost due to skiped rows in read.table)
coln=c("Date","Time","Global_active_power","Global_reactive_power",
       "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
       "Sub_metering_3")

## read data from data file, only read Feb 1 and Feb 2, 2007 data (row 66636 to 69516)
data <- read.table("household_power_consumption.txt", 
                   header = TRUE, 
                   sep=";", 
                   na.strings = "?", 
                   skip = 66636,
                   nrows = 2880,
                   colClasses = colc,
                   col.names = coln)

## make plot -------------------------------------------------------------------------

## convert date and time to datetime class object 
datetime <- paste(data$Date, data$Time)
datetimeobject <- strptime(datetime, 
                           format="%d/%m/%Y %H:%M:%S")

## add new datetime object back to data 
data$DateTime <- datetimeobject

## remove old date and time, and reorder new datetime object to first column  
data <- data[c(-1,-2)]
data <- data[c(8,1,2,3,4,5,6,7)]

## open new png graphics device
png("plot4.png")

## multiple plots
par(mfrow = c(2,2))

## subplot 1 --------------------------------------------
# scatterplot date-time vs. global active power
plot(data$DateTime, data$Global_active_power,
     ## labels for plot
     main = "",
     xlab = "",
     ylab = "Global Active Power",
     ## line type: lines without points 
     type = "l")

## subplot 2 -------------------------------------------
# scatterplot date-time vs. voltage
plot(data$DateTime, data$Voltage,
     ## labels for plot
     main = "",
     xlab = "datetime",
     ylab = "Voltage",
     ## line type: lines without points 
     type = "l")

## subplot 3 -------------------------------------------
# scatterplot date-time vs. Energy sub_metering1,2,3
plot(data$DateTime, data$Sub_metering_1,
     ## labels for plot
     main = "",
     xlab = "",
     ylab = "Energy sub metering",
     ## color
     col = "black",
     ## line type: lines without points 
     type = "l")
points(data$DateTime, data$Sub_metering_2,
       ## color
       col = "red",
       ## line type: lines without points 
       type = "l")
points(data$DateTime, data$Sub_metering_3,
       ## color
       col = "blue",
       ## line type: lines without points 
       type = "l")
## add legend in top-right corner
legend("topright", 
       ## line, not point
       lty = 1,
       ## labels
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       bty = "n",
       ## change size/spacing of legend to better fit sub-plot
       cex = 0.9)

## subplot 4 -------------------------------------------
# scatterplot date-time vs. global reactive power
plot(data$DateTime, data$Global_reactive_power,
     ## labels for plot
     main = "",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     ## line type: lines without points 
     type = "l")

## finish graphic device plot
dev.off()
