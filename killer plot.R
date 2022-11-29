### Killer Plot Stuff

cat("\014")
setwd("C:/Users/tyler/Downloads")

bike_df <- read.csv("202208-capitalbikeshare-tripdata.csv")

library(grid)

rm(list = ls())


## calculate bearings

# install.packages("geosphere")
library(geosphere)
bike_df$bearings <- bearing(bike_df[, c("start_lng", "start_lat")], bike_df[, c("end_lng", "end_lat")])

#convert to radians
bike_df$bearings <- -(bike_df$bearings * pi / 180 - pi/2)
bike_df$circle_x <- cos(bike_df$bearings)
bike_df$circle_y <- sin(bike_df$bearings)



bike_df <- subset(bike_df, start_station_name != "")
bike_df <- subset(bike_df, end_station_name != "")


library(tidyverse)

bike_prepped <- bike_df %>% group_by(start_station_name, end_station_name) %>% 
  summarise(count = n(),
            bearings = mean(bearings))
bike_prepped$circle_x <- cos(bike_prepped$bearings)
bike_prepped$circle_y <- sin(bike_prepped$bearings)

station_plot_df <- bike_df %>% group_by(start_station_name) %>% 
  summarise(count = n(),
            start_lat = mean(start_lat),
            start_lng = mean(start_lng))

my_sf <- st_as_sf(station_plot_df, coords = c('start_lng', 'start_lat'))


##Function for scaling counts
opacity_scale <- function(x){(x-min(x))/(max(x)-min(x))}


## Killer Plot Function
killer_plot <- function(df, station_name, station_number = 5){
  
  #subset for desired station
  station_df <- subset(df, start_station_name == station_name)
  
  #find top n stations
  top.n.stations <- station_df[order(-station_df$count),]$end_station_name[1:station_number] 
  
  #set up grid
  grid.newpage()
  vp <- viewport(x = .325, y = 0.65, width = 0.7, height = 0.7)
  pushViewport(vp)
  grid.circle(x = .5, y = .5, r = 0.4, gp = gpar(fill = "black"), default.units = "native")
  grid.circle(x = .5, y = .5, r = 0.38, default.units = "native")
  
  r = 0.38
  
  station_df$circle_x <- station_df$circle_x * r + 0.5
  station_df$circle_y <- station_df$circle_y * r + 0.5
  
  #determine opacity
  station_df$opacity <- opacity_scale(station_df$count)
  
  
  #iterate through trips to draw lines
  for (i in 1:nrow(station_df)){
    angle = station_df[i, "bearings"]
    grid.lines(x = c(.5, station_df$circle_x[i]), y = c(.5, station_df$circle_y[i]), 
               default.units = "native", gp = gpar(lwd = 3, alpha = station_df$opacity[i]))
  }
  
  
  grid.circle(x=.5, y = .5, r = 0.03, gp = gpar(fill = "gray"), default.units = "native")
  
  popViewport()
  vp2 <- viewport(x = .7, y = 0.25, width = 0.6, height = 0.55)
  my_sf$group <- as.factor(ifelse(station_plot_df$start_station_name == station_name, "1", 
                                  ifelse(station_plot_df$start_station_name %in% top.n.stations, "2", "0")))
  #this is not part of the killer plot, so ggplot is okay
  plota <- ggplot(my_sf) + 
    geom_sf(aes(color = group))+
    scale_color_manual(values = c("black", "green", "red"))+
    theme_void()+    
    theme(legend.position = "none")

  print(plota, vp = vp2)
}

## second argument is selecting center station, third is number of stations to highlight in red on the second map.

killer_plot(df = bike_prepped, station_name = names(sort(table(bike_df$start_station_name), decreasing= TRUE))[8], 15)



                  

