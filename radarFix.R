###################################
##Radar Plot Code
##########################################
##Assumes d is in the form:
# seg  meanAcc sdAcc   meanAccz sdAccz meanSpd   sdSpd   cluster
# 388  -0.038   1.438   -0.571  0.832  -0.825   0.095       1
##where seg is the individual instance identifier
##cluster is the cluster membership
##and the variables from meanACC to sdSpd are used for the clustering
##and thus should be individual lines on the radar plot
radarFix = function(d){
  ##assuming the passed in data frame 
  ##includes only variables you would like plotted and segment label
  d$seg=as.factor(d$seg)
  ##find increment
  angles = seq(from=0, to=2*pi, by=(2*pi)/(ncol(d)-2))
  ##create graph data frame
  graphData= data.frame(seg="", x=0,y=0)
  graphData=graphData[-1,]
  
  
  
  for(i in levels(d$seg)){
    segData= subset(d, seg==i)
    for(j in c(2:(ncol(d)-1))){
      ##set minimum value such that it occurs at 0. (center the data at -3 sd)
      segData[,j]= segData[,j]+3
      
      graphData=rbind(graphData, data.frame(seg=i, 
                                            x=segData[,j]*cos(angles[j-1]),
                                            y=segData[,j]*sin(angles[j-1])))
    }
    ##completes the connection
    graphData=rbind(graphData, data.frame(seg=i, 
                                          x=segData[,2]*cos(angles[1]),
                                          y=segData[,2]*sin(angles[1])))
    
  }
  graphData
  
}