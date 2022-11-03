setwd("~/Library/Mobile Documents/com~apple~CloudDocs/Documents/Sem 1/STAT 405/City Bike Data")

# Recreate dplyr plot in SQL
library(RSQLite)

# Import csv as SQL
dcon <- dbConnect(SQLite(), dbname = "mydba.sqlite")
table <- read.csv(paste0("Washington,DC,USA weather 2022-08-01 to 2022-08-31.csv"))
dbWriteTable(conn = dcon, name = "weather", 
             table, append = TRUE, row.names = FALSE)
dbListTables(dcon)

# Create query for average based on condition
res <- dbSendQuery(conn = dcon, "
SELECT conditions, avg(temp)
FROM weather
GROUP BY conditions
ORDER BY avg(temp) DESC;
")

# store results in df
conditions <- dbFetch(res, -1)
conditions

# Plot graph
plot(pull(table, var = "temp"), type = "l", lwd = "3",
     xlab = "Day of month in August 2022",
     ylab = "Temperature (°F)",
     main = "Temperature in DC in August 2022 with 
     Average Temp based on Weather Condition")

# add lines for average temp of conditions
abline(h = conditions[1:4,2], lwd = "2", col = c("gray", "orange", "red","blue"))

# add legend
legend("topright", c("Partially Cloudy", "Rain, Partially Cloudy", 
                     "Clear", "Rain, Overcast"),
       col = c("gray", "orange", "red", "blue"), 
       cex = 0.7, lty = 1)

