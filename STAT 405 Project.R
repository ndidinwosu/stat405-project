
#Code For rank plot
setwd("C:/Users/tyler/Downloads")
bike_data <- read.csv("202208-capitalbikeshare-tripdata.csv")



# bike_data$duration <-  as.numeric(bike_data$ended_at - bike_data$started_at)

# hist(bike_data$duration[bike_data$duration < 3000])
# hist(bike_data$started_at, breaks = 'day', freq = TRUE)
# bike_data$started_at[1]

# bike_data$weekday <-as.Date(bike_data$started_at)
# week_day_set <- subset(bike_data, weekday < as.Date("2022-08-08"))
# week_day_set$weekday <- format(week_day_set$weekday, "%a")
# week_day_set$weekdayn <- as.numeric(format(week_day_set$started_at, "%w"))
# hist(week_day_set$weekdayn, breaks = -.5+0:7, labels = unique(week_day_set$weekday[order(week_day_set$weekdayn)]), xlab = "", xaxt = "n",  main ="Histogram of Usage Frequency Per Day of Week", col = "deepskyblue")


library(dplyr)

bike_data$started_at <- as.POSIXct(bike_data$started_at, tz = "EST")
bike_data$ended_at <-as.POSIXct(bike_data$ended_at, tz = "EST")
bike_data$date <- format(bike_data$started_at, '%Y-%m-%d')


bike_data_sub <- subset(bike_data, select = c("start_station_name", "end_station_name", "date"))
bike_data_sub <- bike_data_sub %>% 
  add_count(start_station_name, name = 'start_occurance')
bike_data_sub <- bike_data_sub %>%
  add_count(end_station_name, name = 'end_occurance')
# View(bike_data_sub)

#Only use 10 most common stations
bike_data_sub <- subset(bike_data_sub, end_station_name %in% names(sort(table(bike_data_sub$start_station_name),decreasing=TRUE)[2:11]))
bike_data_sub <- subset(bike_data_sub, start_station_name %in% bike_data_sub$end_station_name)

length(unique(bike_data_sub$start_station_name))
length(unique(bike_data_sub$end_station_name))


bike_sub2 <- bike_data_sub %>%
  group_by(date) %>%
  add_count(start_station_name, name = 'occurance_by_day') %>%
  ungroup()
  
bike_sub2 <- bike_sub2 %>% distinct(start_station_name, date, .keep_all=TRUE)

bike_sub3 <- bike_sub2 %>%
  group_by(date) %>%
  arrange(date, desc(occurance_by_day), start_station_name) %>%
  mutate(rank=row_number())%>%
  ungroup()

bike_sub3$date <- as.Date(bike_sub3$date)

library(ggplot2)
ggplot(bike_sub3, aes(x=date, y = rank, group = start_station_name))+
  geom_line(aes(color = start_station_name), size = 2, alpha = .75)+
  geom_point(aes(color = start_station_name), size = 4, alpha = .75)+
  scale_y_reverse(breaks = 1:10)+
  scale_color_brewer(palette = "Paired", name = "Station Name")+
  scale_x_date(date_breaks = "6 days")+
  labs(title = "Daily Usage Rank of the Top 10 Most Common Starting Stations", x = "Date", y = "Rank")

