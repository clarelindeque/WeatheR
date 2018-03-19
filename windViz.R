# Produces the following plots:
#   Wind rose using one year's data
#   Seasonal wind roses
#   Monthly wind roses

require(lubridate)
require(ggplot2)
require(RColorBrewer)
source("prepareData.R")
source("windrose.R")
source("CreateRadialPlot.R")

# Wind
windData <- read.csv(file="wind.csv", header=TRUE, skip=2,
                     stringsAsFactors=FALSE, 
                     col.names=c("utc", "date", "time", "direction", "max_speed", "gust", "speed"))
myData <- prepareData(windData)

# select out one year's worth of data
myData <- myData[ymd(myData$date) > ymd(myData$date[nrow(myData)])-years(1),]

p.wr2 <- plot.windrose(data = myData,
                       spd = "speed",
                       dir = "direction") 
ggsave(filename="windrose.png", width=8, height=8, dpi=300)

p.wr2 + facet_wrap(~month, ncol = 4)
ggsave(filename="month_wind.png", width=8, height=8, dpi=300)

p.wr2 + facet_wrap(~season, ncol = 2) 
ggsave(filename="season_wind.png", width=8, height=8, dpi=300)




