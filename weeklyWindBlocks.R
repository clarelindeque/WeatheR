# Load required libraries

library(ggplot2)
library(reshape)
library(lubridate)
library(zoo)
library(openair)
library(scales)
library(grid)
library(extrafont)
library(RColorBrewer)

source('prepareData.R')

loadfonts()

# Read data from csv file 

df <- read.csv(file="wind.csv", header=TRUE, skip=2,
               stringsAsFactors=FALSE, 
               col.names=c("utc", "date", "time", "direction", "maxSpeed", "gust", "speed"))
df <- prepareData(df)

df$year <- year(df$date)
df$week <- week(df$date)

col<-brewer.pal(9,"Spectral")
col <- rev(col)

png(filename = "WindSpeedWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df,aes(x=year,y=week,fill=speed))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Wind speed (knots)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly wind speeds in Sun Valley\n")+
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

# Day and night time wind speeds

night <- c("19:00", "20:00", "21:00", "22:00", "23:00", "0:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00")
df_night <- subset(df, time %in% night)

`%ni%` <- Negate(`%in%`)
df_day <- subset(df, time %ni% night)

png(filename = "WindSpeedDayWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df_day,aes(x=year,y=week,fill=speed))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Wind speed (knots)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly daytime wind speeds in Sun Valley\n")+
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

png(filename = "WindSpeedNightWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df_night,aes(x=year,y=week,fill=speed))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Wind speed (knots)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly nighttime wind speeds in Sun Valley\n")+
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

# Wind gusts

col<-brewer.pal(9,"Reds")

png(filename = "WindGustWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df,aes(x=year,y=week,fill=gust))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Wind gust (knots)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly wind gusts in Sun Valley\n")+
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

# Can we visualise wind direction similarly? Make the colour scheme wrap

col<-brewer.pal(5,"Greens")
col <- c(rev(col), col[2:5] )

png(filename = "WindDirectionWeek.png",height=10,width=10,
    bg = "white",units='in', res = 400, family = "",  type = "cairo-png")

ggplot(data=df,aes(x=year,y=week,fill=direction))+ geom_tile(colour=NA,size=0.65)+
  theme_bw()+
  scale_fill_gradientn(colours=col,name=as.expression(expression( paste("Wind direction (degrees)"))))+
  coord_equal(ratio=0.2)+
  ylab("WEEK OF YEAR\n")+
  xlab("\nYEAR")+
  scale_x_continuous(expand = c(0,0),breaks = seq(2013, 2016, 1)) +
  scale_y_discrete(expand = c(0,0),breaks = seq(0,52,4))+
  ggtitle("Average weekly wind direction in Sun Valley\n")+
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