library(ggplot2)
library(reshape)
library(lubridate)
library(zoo)
library(openair)
library(scales)
library(grid)
library(extrafont)
library(plyr)
library(WeatheR)

loadfonts()

# Read data from csv file 

df <- read.csv(file="summer2014-2015_wind.csv", header=TRUE, skip=2,
                     stringsAsFactors=FALSE, 
                     col.names=c("utc", "date", "time", "wd", "max_speed", "gust", "ws"))
df <- prepareData(df)

df$date <- as.POSIXct(df$date)

# Plot 'calendar plot' and save as png

png(filename = "CalendarPlotSummer2014_wind.png",height=8,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

calendarPlot(df, pollutant = "ws", year="2014", statistic="mean",
             main = "Daily wind speed with wind-speed scaled direction overlay (2014-2015)\n",
             key.header = "Wind speed (knots)",
             limits = c(0, 16),
             cols="heat", annotate = "ws")

dev.off()

# Second calendar plot

png(filename = "CalendarPlotSummer2015_wind.png",height=8,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

calendarPlot(df, pollutant = "ws", year="2015", statistic="mean",
             main="",
             key.header = "Wind speed (knots)",
             limits = c(0, 16),
             cols="heat", annotate = "ws")

dev.off()

# Plot the weekly average wind speed
df_summarised1 <- ddply(df[,c("date", "ws")],.(date), summarize, wind = mean(ws,na.rm=T), .inform=T)
df_summarised2 <- ddply(df[,c("date", "ws")],.(date), summarize, windmax = max(ws,na.rm=T), .inform=T)
df_summarised3 <- ddply(df[,c("date", "ws")],.(date), summarize, windmin = min(ws,na.rm=T), .inform=T)
df_summarised <- merge(df_summarised1, df_summarised2)
df_summarised <- merge(df_summarised, df_summarised3)

png(filename = "Summer2015_wind_line.png",height=8,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df_summarised, aes(x=date, y=wind, group=1 )) +
  xlab("Date") + ylab("Wind speed (knots)") + 
  ggtitle("Summer 2014-2015 daily average wind speed") +
  theme_bw() +
  geom_ribbon(aes(ymin=windmin, ymax=windmax), fill="#fee6ce", colour=NA) +
  geom_line(colour="#e6550d", size=1)

dev.off()
