
##Checkpoint 5 Stuff
dcon <- dbConnect(SQLite(), dbname = "Bike Project.db")

dbSendQuery(conn = dcon, "
PRAGMA foreign_keys = ON;
")


## List tables
dbListTables(dcon)

## Fields in a table
dbListFields(dcon, "BikeShare")


## Join two dataframes based on start date
res <- dbSendQuery(conn = dcon, "
SELECT *
FROM (SELECT *, date(started_at) as date FROM BikeShare) as a, AugustWeather
WHERE a.date = AugustWeather.datetime
ORDER BY a.date")
mydf <- dbFetch(res,-1)
dbClearResult(res)

## Search Description for presence of After Noon Rain
library(stringr)
mydf$after_noon_rain <- str_detect(mydf$description, "afternoon rain")
mydf$after_noon_rain <-  factor(mydf$after_noon_rain, labels = c("No Afternoon Rain", "Afternoon Rain"))
 
#Extract Hour From Time Stamp 
library(lubridate)
mydf$hour <- hour(mydf$started_at)

#Plot it
library(ggplot2)
ggplot(data = mydf, aes(x = hour))+
  geom_histogram(stat = "count", fill = "deepskyblue3")+
  facet_wrap(~after_noon_rain, scales = "free")+
  labs(title = "Effects of Afternoon Rain on Bike Usage", y = "Trip Count", x = "Hour of Day", 
       facet = c("No Rain", "Rain"))+
  theme_bw()

##Description
## This graph shows how the presence of afternoon rain will affect the distribution of bike usage throughout the day. When there is no Afternoon rain, there is usually a sharp spike in usage around 5-6pm. When there is rain, however, the hours from 7am-6pm see more even usage levels. The shape of the beginning or end of the day is still not effected very much. 
