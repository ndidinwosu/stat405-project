# create new plot with sql
library(RSQLite)
library(ggplot2)

# Import csv as SQL
dcon <- dbConnect(SQLite(), dbname = "mydba.sqlite")
table <- read.csv(paste0("Washington,DC,USA weather 2022-08-01 to 2022-08-31.csv"))
dbWriteTable(conn = dcon, name = "weather", 
             table, append = TRUE, row.names = FALSE)
dbListTables(dcon)
table2 <- read.csv(paste0("C:/Users/calvi/Downloads/202208-capitalbikeshare-tripdata/202208-capitalbikeshare-tripdata.csv"))
dbWriteTable(conn = dcon, name = "bikes", 
             table2, append = TRUE, row.names = FALSE)
dbListTables(dcon)

# Create query for average based on condition

res <- dbSendQuery(conn = dcon, "
              SELECT start_station_name, end_station_name, COUNT(*) as num_trips
              FROM bikes b
              GROUP BY start_station_name, end_station_name
              ORDER BY (-1 * num_trips) 
              LIMIT 10;
                   ")

# store results in df
station_travel <- dbFetch(res, -1)
station_travel

ggplot(data = station_travel[-1,], aes(x = start_station_name, y = num_trips)) +
  geom_bar(stat = 'identity') +
  coord_flip() +
  ggtitle("Concentration of Trip Starts") +
  labs(x = "Number of Trips", y = "Start Station Name") +
  theme_minimal()




