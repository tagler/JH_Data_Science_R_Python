## ======================================================================
## PLOT 1 ===============================================================
## ======================================================================

library(dplyr)

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

## group by year and then sum emissions values 
by_year <- group_by(NEI_DF, year)
year_sum <- summarize(by_year, sum=sum(Emissions))

## open new png graphics device
png("plot1.png")

## make plot
plot(year_sum$year, year_sum$sum,
     main = expression(paste("Total ", PM[2.5], " Emissions in the United States 1999-2008")),
     xlab = "Year",
     ylab = expression(paste("Total ", PM[2.5], " Emissions (Tons)")),
     col = "black",
     type = "p",
     pch = 19,
     xlim = c(1999,2008),
     ylim = c(3e06,8e06),
     axes = FALSE)

## add linear fit line
fit <- lm(year_sum$sum ~ year_sum$year)
abline(fit, col = "black", lty="dashed", lwd = 2 )

## add axes with correct steps, add box around plot
axis(side=1, at=c(1999,2002,2005,2008))
axis(side=2, at=c(3e06,4e06,5e06,6e06,7e06,8e06))
box()

## finish graphic device plot
dev.off()

## ======================================================================
## PLOT 2 ===============================================================
## ======================================================================

library(dplyr)

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make 
## a plot answering this question.

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

# select data from 24510
data_24510 <- filter(NEI_DF, fips == "24510")

## group by year and then sum emissions values 
by_year <- group_by(data_24510, year)
year_sum <- summarize(by_year, sum=sum(Emissions))

## open new png graphics device
png("plot2.png")

## make plot
plot(year_sum$year, year_sum$sum,
     main = expression(paste("Total ", PM[2.5], " Emissions in the Baltimore City, MD 1999-2008")),
     xlab = "Year",
     ylab = expression(paste("Total ", PM[2.5], " Emissions (Tons)")),
     col = "black",
     type = "p",
     pch = 19,
     xlim = c(1999,2008),
     ylim = c(1500,3500),
     axes = FALSE)

## add linear fit line
fit <- lm(year_sum$sum ~ year_sum$year)
abline(fit, col = "black", lty="dashed", lwd = 2 )

## add axes with correct steps, add box around plot
axis(side=1, at=c(1999,2002,2005,2008))
axis(side=2, at=c(1500,2000,2500,3000,3500))
box()

## finish graphic device plot
dev.off()

## ======================================================================
## PLOT 3 ===============================================================
## ======================================================================

library(dplyr)
library(ggplot2)
library(grid)

## Of the four types of sources indicated by the type (point, nonpoint, onroad, 
## nonroad) variable, which of these four sources have seen decreases in emissions 
## from 1999–2008 for Baltimore City? Which have seen increases in emissions from 
## 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

# select data from 24510
data_24510 <- filter(NEI_DF, fips == "24510")

## group by year+type and then sum emissions values 
by_year_type <- group_by(data_24510, year, type)
all_type_year_sum <- summarize(by_year_type, sum=sum(Emissions))

## make plot
g <- ggplot(all_type_year_sum, aes(x=year, y=sum))

## add layers
g2 <- g + geom_point() + 
  facet_grid(. ~ type) +
  geom_smooth(method = "lm", se=FALSE, col="black", lty="dashed") +
  labs(x = "Year") +
  labs(y = expression(paste("Total ", PM[2.5], " Emissions (Tons)"))) +
  labs(title = expression(paste("Total ", PM[2.5], " Emissions in the Baltimore City, MD 1999-2008")) ) +
  theme_bw() +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  theme(panel.margin = unit(.8, "lines"))

## export plot
ggsave(filename="plot3.png", plot = g2)

## ======================================================================
## PLOT 4 ===============================================================
## ======================================================================

library(dplyr)
library(ggplot2)
library(grid)
library(scales)

## Across the United States, how have emissions from coal combustion-related
## sources changed from 1999–2008?

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

## combine data, add source info to emissions data
NEI_SCC_DF <- inner_join(NEI_DF, SCC_DF, by="SCC")

## NOTE: question is not clear on how to select a "coal cumbustion" source
## Hence, I did the following:
## 1.) Short.Name contains "coal" and then
## 2.) Sort.Name coantains "comb" 
## Short.Name contains most detailed information, most uses of "coal"

## select coal sources 
data_coal <- filter(NEI_SCC_DF, grepl("coal",Short.Name, ignore.case = TRUE))
## select combustion sources 
data_coal_comb <- filter(data_coal, grepl("comb",Short.Name, ignore.case = TRUE))

## group by year and then sum emissions values 
by_year <- group_by(data_coal_comb, year)
year_sum <- summarize(by_year, sum=sum(Emissions))

## make plot
g <- ggplot(year_sum, aes(x=year, y=sum))

## add layers
g2 <- g + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, col="black", lty="dashed") +
  labs(x = "Year") +
  labs(y = expression(paste("Total ", PM[2.5], " Emissions from Coal Combustion Sources (Tons)"))) +
  labs(title = expression(paste("Total ", PM[2.5], " Emissions from Coal Combustion in US 1999-2008")) ) +
  theme_bw() +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  scale_y_continuous(label=scientific_format())

## export plot
ggsave(filename="plot4.png", plot = g2)

## ======================================================================
## PLOT 5 ===============================================================
## ======================================================================

library(dplyr)
library(ggplot2)
library(grid)
library(scales)

## How have emissions from motor vehicle sources changed from 1999–2008
## in Baltimore City?

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

## combine data, add source info to emissions data
NEI_SCC_DF <- inner_join(NEI_DF, SCC_DF, by="SCC")

## select data from baltimore city  24510
data_24510 <- filter(NEI_SCC_DF, fips == "24510")

## NOTE: question is not clear on how to select a "motor vehicle source"
## The definition of a "motor vechile" is rather vague and subject to interpretation
## I decided to select only highway vehicles from the data set 
## Boats, trains, airplanes, equipment, etc. were not included
## Hence, I did the following:
## 1.) Short.Name containing "Highway Veh"

## select mobile sources
data_24510_mv <- filter(data_24510, grepl("Highway Veh", Short.Name, ignore.case=TRUE))

## group by year and then sum emissions values 
by_year <- group_by(data_24510_mv, year)
year_sum <- summarize(by_year, sum=sum(Emissions))

## make plot
g <- ggplot(year_sum, aes(x=year, y=sum))

## add layers
g2 <- g + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, col="black", lty="dashed") +
  labs(x = "Year") +
  labs(y = expression(paste("Total ", PM[2.5], " Emissions from Motor Vehicle Sources (Tons)"))) +
  labs(title = expression(paste("Total ", PM[2.5], " Emissions from Motor Vehicles in Baltimore City, MD 1999-2008")) ) +
  theme_bw() +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  scale_y_continuous(breaks=c(0,100,200,300,400,500,600)) 

## export plot
ggsave(filename="plot5.png", plot = g2)

## ======================================================================
## PLOT 6 ===============================================================
## ======================================================================

library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(scales)

## Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

## import data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## convert to dplyr table data frame objects
NEI_DF <- tbl_df(NEI)
SCC_DF <- tbl_df(SCC)

## combine data, add source info to emissions data
NEI_SCC_DF <- inner_join(NEI_DF, SCC_DF, by="SCC")

## select data from baltimore city 24510 and LA 06037
data_24510_06037 <- filter(NEI_SCC_DF, fips == "24510" | fips == "06037")

## NOTE: question is not clear on how to select a "motor vehicle source"
## The definition of a "motor vehicle" is rather vague and subject to interpretation
## I decided to select only highway vehicles from the data set 
## Boats, trains, airplanes, equipment, etc. were not included
## Hence, I did the following:
## 1.) Short.Name containing "Highway Veh"

## select mobile sources
data_24510_06037_mv <- filter(data_24510_06037, grepl("Highway Veh", Short.Name, ignore.case=TRUE))

## group by year and fips code and then sum emissions values 
by_year_fips <- group_by(data_24510_06037_mv, year,fips)
year_sum <- summarize(by_year_fips, sum=sum(Emissions))

## make plot 1 (emissions vs. year)
g1 <- ggplot(year_sum, aes(x=year,y=sum,color=fips)) +
  geom_point(alpha = 1, size = 3) +      
  stat_smooth(method = "lm", lty="dashed", size=1) +
  scale_color_manual(values = c("red", "blue")) +
  labs(title = expression(paste("Total ", PM[2.5], " Emissions from Motor Vehicles 1999-2008"))) +
  labs(x = "Year") +
  labs(y = expression(paste("Total ", PM[2.5], " Emissions (Tons)"))) +
  theme_bw() +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  scale_y_continuous(breaks=c(0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500)) +
  theme(legend.position = "none", 
        plot.title = element_text(vjust=1.5))

## split into separate data table objects
year_sum_06037 <- filter(year_sum, fips == "06037" )
year_sum_24510 <- filter(year_sum, fips == "24510" )

## create and add percent change from 1999 column to data
year_sum_06037$percent.change <- NA
year_sum_24510$percent.change <- NA

## calclate percetn change from 1999 
for(i in 1:3){
  year_sum_06037[i+1,4] <- (year_sum_06037[i+1,3] - year_sum_06037[1,3]) /
    (year_sum_06037[1,3]) *100
}
for(i in 1:3){
  year_sum_24510[i+1,4] <- (year_sum_24510[i+1,3] - year_sum_24510[1,3]) /
    (year_sum_24510[1,3]) *100
}

## combine data and add range to year column 
year_sum_percentchange <- rbind(year_sum_06037, year_sum_24510)
year_sum_percentchange[2,1] <- "1999 to 2002"
year_sum_percentchange[3,1] <- "1999 to 2005"
year_sum_percentchange[4,1] <- "1999 to 2008"
year_sum_percentchange[6,1] <- "1999 to 2002"
year_sum_percentchange[7,1] <- "1999 to 2005"
year_sum_percentchange[8,1] <- "1999 to 2008"
year_sum_percentchange <- year_sum_percentchange[c(2,3,4,6,7,8),]

## make plot 2 (percent changes)
g2 <- ggplot(year_sum_percentchange, aes(x=year,y=percent.change,fill=fips)) +
  scale_fill_manual(values =  c("red", "blue"), name="Location:", labels=c(" Los Angeles County, CA", " Baltimore City, MD")) +
  geom_bar (position="dodge",stat="identity") +    
  coord_cartesian(ylim = c(-80, 20)) +
  labs(title = expression(paste("Percent Change in Total ", PM[2.5], " Emissions from Motor Vehicles 1999-2008"))) +
  labs(x = "Year Range") +
  labs(y = "Percent Change (%)") +
  theme_bw() +
  scale_y_continuous(breaks=c(-80,-70,-60,-50,-40,-30,-20,-10,0,10,20)) +
  theme(legend.position = c(0.83,0.95), 
        legend.direction = "vertical",
        plot.title = element_text(vjust=1.6)) 

# start png plot
png("plot6.png", width = 1200, height = 800,
    units = "px")

## arange two plots on one file
g3 <- grid.arrange(g1, g2, 
                   ncol = 2 )

## end png plot
dev.off()

