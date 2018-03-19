# Produces the following charts
#   Radial monthly temperature range chart


require(lubridate)
require(ggplot2)
require(RColorBrewer)
source("prepareData.R")
source("windrose.R")
source("CreateRadialPlot.R")


# Temperature
tempData <- read.csv(file="temperature.csv", header=TRUE, skip=2,
                     stringsAsFactors=FALSE, 
                     col.names=c("utc", "date", "time", "temperature"))
myData <- prepareData(tempData)
# select out one year's worth of data
myData <- myData[ymd(myData$date) > ymd(myData$date[nrow(myData)])-years(1),]

monthTempMin <- tapply(myData$temperature, myData$month, min)
monthTempMax <- tapply(myData$temperature, myData$month, max)
monthTempMean <- tapply(myData$temperature, myData$month, mean)
months <- data.frame(cbind(monthTempMin, monthTempMean, monthTempMax))
colnames(month) <- c("Min", "Mean", "Max")
rownames(month) <- levels(myData$month)
plotdf <- cbind(c(1:3), t(months))
colnames(plotdf)[1] <- "group"
rownames(plotdf) <- c("Min", "Mean", "Max")

CreateRadialPlot(plotdf, grid.max=max(plotdf[3,]), legend.title="Temperature", 
                 label.gridline.min=TRUE, background.circle.colour="white",
                 grid.mid = round(mean(myData$temperature),1), grid.min = min(plotdf[1,-1]))
dev.copy(png, file="month_temp.png", bg="transparent", width=1024, height=1024)
dev.off()