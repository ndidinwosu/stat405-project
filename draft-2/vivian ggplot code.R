# Duration by Date for Lincoln Memorial Station
library(ggplot2)

city_bike <- read.csv("August 2022.csv")
start_time <- city_bike$started_at
end_time <- city_bike$ended_at
city_bike$start_time <- as.POSIXct(start_time,tz="EST")
city_bike$end_time <- as.POSIXct(end_time,tz="EST")
city_bike$duration <- as.numeric((city_bike$end_time - city_bike$start_time) / 60)

# Identify top station (Lincoln Memorial)
tab <- table(city_bike$start_station_name)
sort(tab)
linc_mem <- subset(city_bike, city_bike$start_station_name == "Lincoln Memorial" &
                     city_bike$end_station_name != "Lincoln Memorial")
linc_mem <- drop_na(linc_mem)

ggplot(data = linc_mem, aes(x = start_time, y = duration)) +
  geom_point(color = "skyblue") +
  ggtitle("Duration by Date for Lincoln Memorial Station, August 2022") +
  xlab("Date") + ylab("Rental Duration (min)")
