### Killer Plot Stuff

# setwd("C:/Users/tyler/Downloads")

bike_df <- read.csv("202208-capitalbikeshare-tripdata.csv")

library(grid)

#helpful grid function
grid.newpage()
viewport(width = 0.4, height = 0.4, x = 0.75, y = 0.35)
grid.show.viewport(vp)
pushViewport(vp)
popViewport()
grid.circle(x = 0.5, y = 0.5, r = 0.25)

#### Playground
grid.newpage()
#I don't really know how all these parameters work, but this lets us set the (0,0) as the center of the plot
ex_vp <- viewport(x = 1, y = 1,
                  just = c("center", "center"),
                  height = 1, width = 1, 
                  xscale = c(0,1), yscale = c(0,1))

pushViewport(ex_vp)
grid.circle(x = 0, y = 0, r = 0.4, gp = gpar(fill = "black"), default.units = "native")
grid.circle(x = 0, y = 0, r = 0.38, default.units = "native")

grid.circle(x=0, y = 0, r = 0.03, gp = gpar(fill = "gray"), default.units = "native")

r = 0.38
angle = pi

grid.lines(x = c(0, r*cos(angle)), y = c(0, r*sin(angle)), default.units = "native")
grid.circle(x=0, y = 0, r = 0.03, gp = gpar(fill = "gray"), default.units = "native")
grid.circle(x=0, y = 0, r = 0.03, gp = gpar(fill = "gray"), default.units = "native")





# grid.circle(x = 0.5, y = 0.5, r = 0.2, gp = gpar(col = "blue", fill = "transparent", alpha = 0.2))
# set fill to "transparent" if you want to see through shapes

length(unique(bike_df$start_station_name))

grid.circle

