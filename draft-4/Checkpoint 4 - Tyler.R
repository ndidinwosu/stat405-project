library(RSQLite)

dcon <- dbConnect(SQLite(), dbname = "Bike Project.db")

dbSendQuery(conn = dcon, "
PRAGMA foreign_keys = ON;
")


## List tables
dbListTables(dcon)

## Fields in a table
dbListFields(dcon, "BikeShare")

dbListFields(dcon, "AugustWeather")


##conditions
res <- dbSendQuery(conn = dcon, "
SELECT conditions, avg(count) as Average FROM (
SELECT a.date, conditions, count(*) as count
FROM (SELECT date(started_at) as date FROM BikeShare) as a, AugustWeather
WHERE a.date = AugustWeather.datetime 
GROUP BY a.date, conditions
) as counts
GROUP BY conditions

 ")
mydf <- dbFetch(res, -1)
dbClearResult(res)
mydf


library(ggplot2)

ggplot(data = mydf, aes(x = conditions, y = Average))+
  geom_bar(stat = "identity", fill = "deepskyblue")+
  labs(title = "How Weather Conditions Affects Bike Usage in Washington D.C.", x = "Weather Conditions",
       y = "Daily Average of Trips per Condition")+
  theme_bw()+
  theme(axis.title.x = element_text(size = 13), axis.title.y = element_text(size = 13))+
  theme(axis.text.x = element_text(size = 11, color = 'black'), axis.text.y = element_text(size = 11, color = 'black') )


