require(lubridate)

prepareTempData <- function(data){
  myData <- data
  myData$utc <- strptime(myData$utc, format="%d/%m/%Y %H:%M", tz="")
  myData$date <- strptime(myData$date, format="%d/%m/%Y", tz="")
  # Add on months
  myData <- cbind(myData, months(myData$date))
  colnames(myData)[ncol(myData)] <- "month"
  myData$month <- factor(myData$month, 
                         levels = c("January", "February", "March", "April",
                                    "May", "June", "July", "August", "September",
                                    "October", "November", "December"))
  
  # Add on seasons
  seasonData <- rep("Summer", times=nrow(myData), ncol=1)
  seasonData[month(myData$date) %in% 2 & day(myData$date) >= 15] <- "Autumn"
  seasonData[month(myData$date) %in% 3:4] <- "Autumn"
  seasonData[month(myData$date) %in% 5 & day(myData$date) < 15] <- "Autumn"
  seasonData[month(myData$date) %in% 5 & day(myData$date) >= 15] <- "Winter"
  seasonData[month(myData$date) %in% 6:7] <- "Winter"
  seasonData[month(myData$date) %in% 8 & day(myData$date) < 15] <- "Winter"
  seasonData[month(myData$date) %in% 8 & day(myData$date) >= 15] <- "Spring"
  seasonData[month(myData$date) %in% 9:10] <- "Spring"
  seasonData[month(myData$date) %in% 11 & day(myData$date) < 15] <- "Spring"
  myData <- cbind(myData, seasonData)
  colnames(myData)[ncol(myData)] <- "season"
  myData$season <- factor(myData$season, levels = c("Summer", "Autumn", "Winter", "Spring"))
  
  prepareData <- myData
}