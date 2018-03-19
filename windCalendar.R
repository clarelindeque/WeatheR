# Load required libraries

library(ggplot2)
library(reshape)
library(lubridate)
library(zoo)
library(openair)
library(scales)
library(grid)
library(extrafont)

source('prepareData.R')

loadfonts()

# Read data from csv file 

df <- read.csv(file="wind2015.csv", header=TRUE, skip=2,
                     stringsAsFactors=FALSE, 
                     col.names=c("utc", "date", "time", "wd", "max_speed", "gust", "ws"))
df <- prepareData(df)
df <- df[,-1]

df$date <- as.POSIXct(df$date)

# Plot 'calendar plot' and save as png

png(filename = "CalendarPlot.png",height=8,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

calendarPlot(df, pollutant = "max_speed", year="2015", statistic="mean",
             main = "Daily maximum wind speed with wind-speed scaled direction overlay (2015)\n",
             key.header = "Maximum wind speed (knots)",
             cols="heat", annotate = "ws")

dev.off()