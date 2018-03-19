# Plots the following:
#   cumulative rainfall
#   number of rainy days per month, per year
#   total monthly rainfall, per month, per year
#
#   Rainfall by month (bar chart)
#   Rainfall by year (bar chart)


library(ggplot2)
library(scales)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(grid)
library(zoo)
library(RColorBrewer)

source("prepareData.R")
source('prepareRainData.R')

# Read data from csv file 

df <- read.csv(file="rain.csv", header=TRUE, skip=2,
               stringsAsFactors=FALSE, 
               col.names=c("utc", "date", "time", "rainrate", "rainfall"))
df <- prepareRainData(df)

df$date <- as.POSIXct(df$date)

df$year <- year(df$date)

df <- subset(df, year >= 2014)
df$year <- as.factor(df$year)

df_cs <- ddply(df[,c("date", "year", "rainfall")],.(year), transform, cumRain = cumsum(rainfall))

# Cumulative rainfall

plot.title = 'Cumulative Rainfall by Year: 2014 - 2016'

cr<-  ggplot(df_cs, aes(x = yday(date), y = cumRain, color = factor(year(date)))) +
  geom_line(size=0.5,linetype='solid') + geom_point(size=1.5) + theme_bw() +
  ggtitle(plot.title) + 
  theme(plot.title = element_text(face = "bold",size = 16,colour="black")) +
  guides(color = guide_legend(title = "Year", title.position = "top")) +
  scale_x_continuous(breaks=c(0,30,60,90,120,150,180,210,240,270,300,330,360)) +
  scale_y_continuous(limits=c(0,800))+
  xlab("Julian Day") + ylab("Rainfall (mm)\n")+
  theme(panel.border = element_rect(colour = "black",fill=F,size=1),
        panel.grid.major = element_line(colour = "grey",size=0.25,linetype='longdash'),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "ivory",colour = "black"),
        legend.position="right") 

cr 

ggsave(cr, file="CumulativeRain.png", width=13, height=7,type = "cairo-png")

# Rain per month
df_daily <- ddply(df_cs,.(date), summarise, dailyRain = sum(rainfall))

df_daily <- cbind(df_daily, months(df_daily$date))  # add month column
colnames(df_daily)[ncol(df_daily)] <- "month"
L <- c("January", "February", "March", "April", "May", "June", "July", "August", "September",
       "October", "November", "December")
df_daily$month <- factor(df_daily$month, levels = L)

df_daily$month <- substr(df_daily$month, 1,3)
df_daily$month <- factor(df_daily$month, levels=substr(L,1,3))

df_daily <- cbind(df_daily, year(df_daily$date))
colnames(df_daily)[ncol(df_daily)] <- "year"
df_mon <- ddply(df_daily, .(year, month), summarise, monthlyRain = sum(dailyRain))
df_mon$month <- substr(df_mon$month, 1,3)
df_mon$month <- factor(df_mon$month, levels=df_mon$month[1:12])

rpmpy <- ggplot(df_mon, aes(x=month, y = monthlyRain, fill=as.factor(year))) + 
  geom_bar(stat="identity") + 
  facet_wrap(~year, nrow=3) +
  theme(legend.title=element_blank())

rpmpy

ggsave(rpmpy, file="MonthlyRainByYear.png", width=13, height=7,type = "cairo-png")

# Rain days

df_rd <- ddply(df_daily, .(year, month), summarise, rainDays =sum(as.numeric(dailyRain>0)))

rdpmpy <- ggplot(df_rd, aes(x=month, y = rainDays, fill=as.factor(year))) + 
  geom_bar(stat="identity") + 
  facet_wrap(~year, nrow=3) +
  theme(legend.title=element_blank())

rdpmpy

ggsave(rdpmpy, file="MonthlyRainDaysByYear.png", width=13, height=7,type = "cairo-png")

# Rain bar charts - monthly and seasonal
rainData <- read.csv(file="rain.csv", header=TRUE, skip=2,
                     stringsAsFactors=FALSE, 
                     col.names=c("utc", "date", "time", "rain_rate", "rainfall"))
myData <- prepareData(rainData)
# select out one year's worth of data
myData <- myData[ymd(myData$date) > ymd(myData$date[nrow(myData)])-years(1),]

seasonRain <- tapply(myData$rainfall, myData$season, sum)
relRain <- (seasonRain - min(seasonRain)) / (max(seasonRain) - min(seasonRain))
blues <- rainbow(length(relRain), s=1, v=1, start=.4, end=.6)
barplot(seasonRain, ylab="Total rainfall (mm)", col=blues)
dev.copy(png, file="season_rain.png", bg="transparent", width=1024, height=1024)
dev.off()

monthRain <- tapply(myData$rainfall, myData$month, sum)
relRain <- (monthRain - min(monthRain)) / (max(monthRain) - min(monthRain))
blues <- rainbow(length(relRain), s=1, v=1, start=.4, end=.6)
barplot(monthRain, ylab="Total rainfall (mm)", col=blues, las=2, cex.names=0.8)
dev.copy(png, file="month_rain.png", bg="transparent", width=1024, height=1024)
dev.off()