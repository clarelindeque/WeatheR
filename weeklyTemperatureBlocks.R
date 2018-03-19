# Load required libraries

library(ggplot2)
library(reshape)
library(lubridate)
library(zoo)
library(openair)
library(scales)
library(grid)
library(extrafont)

source('prepareTempData.R')

loadfonts()

# Read data from csv file 

df <- read.csv(file="temperature.csv", header=TRUE, skip=2,
               stringsAsFactors=FALSE, 
               col.names=c("utc", "date", "time", "temperature"))
df <- prepareTempData(df)

df$year <- year(df$date)
df$week <- week(df$date)

col<- rev(brewer.pal(9,"Spectral"))

png(filename = "TemperatureWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df,aes(x=year,y=week,fill=temperature))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Temperature (", degree,"C)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly air temperatures in Sun Valley\n")+
  theme(panel.background=element_rect(fill="grey90"),
        panel.border=element_rect(colour="white"),
        axis.title.y=element_text(size=10,colour="grey20"),
        axis.title.x=element_text(size=10,colour="grey20"),
        axis.text.y=element_text(size=10,colour="grey20",face="bold"),
        axis.text.x=element_text(size=10,colour="grey20",face="bold"),
        plot.title = element_text(lineheight=1.2, face="bold",size = 14, colour = "grey20"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key.width=unit(c(0.1,0.1),"in"))

dev.off()

png(filename = "TemperatureDots.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

plot.title = 'Daily Air Temperatures in Sun Valley (2013-2016)'

ggplot(data=df, aes(x=date, y=temperature)) +
  geom_jitter(colour="grey40",size=1.5,alpha=0.4) +
  scale_y_continuous(breaks=c(5, 10,15,20,25,30,35,40)) +
  theme_bw()+
  scale_x_datetime(breaks = date_breaks("1 year"), minor_breaks = date_breaks("1 year"), labels=date_format("%b %Y")) +
  xlab("") + ylab(as.expression(expression( paste("Temperature (", degree,"C)") ))) +
  ggtitle(plot.title) +
  theme(plot.title = element_text(face = "bold",size = 16,colour="black")) 

dev.off()

# Try and split into daytime and nighttime temperatures

night <- c("19:00", "20:00", "21:00", "22:00", "23:00", "0:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00")
df_night <- subset(df, time %in% night)

`%ni%` <- Negate(`%in%`)
df_day <- subset(df, time %ni% night)

png(filename = "TemperatureDayTimeWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df_day,aes(x=year,y=week,fill=temperature))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Temperature (", degree,"C)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly daytime air temperatures in Sun Valley\n")+
  theme(panel.background=element_rect(fill="grey90"),
        panel.border=element_rect(colour="white"),
        axis.title.y=element_text(size=10,colour="grey20"),
        axis.title.x=element_text(size=10,colour="grey20"),
        axis.text.y=element_text(size=10,colour="grey20",face="bold"),
        axis.text.x=element_text(size=10,colour="grey20",face="bold"),
        plot.title = element_text(lineheight=1.2, face="bold",size = 14, colour = "grey20"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key.width=unit(c(0.1,0.1),"in"))

dev.off()

png(filename = "TemperatureNightTimeWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df_night,aes(x=year,y=week,fill=temperature))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Temperature (", degree,"C)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly nighttime air temperatures in Sun Valley\n")+
  theme(panel.background=element_rect(fill="grey90"),
        panel.border=element_rect(colour="white"),
        axis.title.y=element_text(size=10,colour="grey20"),
        axis.title.x=element_text(size=10,colour="grey20"),
        axis.text.y=element_text(size=10,colour="grey20",face="bold"),
        axis.text.x=element_text(size=10,colour="grey20",face="bold"),
        plot.title = element_text(lineheight=1.2, face="bold",size = 14, colour = "grey20"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key.width=unit(c(0.1,0.1),"in"))

dev.off()
