library(ggplot2)
library(scales)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(grid)
library(zoo)
library(RColorBrewer)

source('prepareData.R')

# Read data from csv file 

df <- read.csv(file="wind2014.csv", header=TRUE, skip=2,
               stringsAsFactors=FALSE, 
               col.names=c("utc", "date", "time", "direction", "max_speed", "gust", "speed"))
df <- prepareData(df)

df$hour <- as.numeric(format(strptime(df$utc, format = "%Y-%m-%d %H:%M"),format = "%H"))

df_summarised <- ddply(df[, c("month", "hour", "speed")],.(month,hour),summarize, speed = mean(speed,na.rm=T))

png(filename = "WindTime2.png",height=8,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(df_summarised, aes(x=month, y=hour, fill=speed)) +
  geom_tile(colour="grey70") +
  scale_fill_gradientn(colours = rev(topo.colors(7)),name="Wind Speed\n(knots)\n")+
  scale_y_continuous(breaks = seq(0,23),
                     labels=c("12.00am","1:00am","2:00am","3:00am","4:00am","5:00am","6:00am","7:00am","8:00am","9:00am","10:00am","11:00am","12:00pm",
                              "1:00pm","2:00pm","3:00pm","4:00pm","5:00pm","6:00pm","7:00pm","8:00pm","9:00pm","10:00pm","11:00pm")) +
  coord_polar(theta="x") +
  ylab("HOUR OF DAY")+
  xlab("")+
  ggtitle("Wind Speed by month and time of day")+
  theme(panel.background=element_blank(),
        axis.title.y=element_text(size=10,hjust=0.75,colour="grey20"),
        axis.title.x=element_text(size=7,colour="grey20"),
        panel.grid=element_blank(),
        axis.ticks=element_blank(),
        axis.text.y=element_text(size=5,colour="grey20"),
        axis.text.x=element_text(size=10,colour="grey20",face="bold"),
        plot.title = element_text(lineheight=1.2, face="bold",size = 14, colour = "grey20"),
        plot.margin = unit(c(-0.25,0.25,-1,0.25), "in"),
        legend.key.width=unit(c(0.2,0.2),"in"))

dev.off()