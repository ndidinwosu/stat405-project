setwd("~/Library/Mobile Documents/com~apple~CloudDocs/Documents/Sem 1/STAT 405/City Bike Data")

weather <- read.csv("Washington,DC,USA weather 2022-08-01 to 2022-08-31.csv")

library(dplyr)

# Determine average temps based on condition
conditions_means <- weather %>%
  group_by(conditions) %>%
  summarise(
    mean = mean(temp)
  )

# Plot graph
plot(pull(weather, var = "temp"), type = "l", lwd = "3",
     xlab = "Day of month in August 2022",
     ylab = "Temperature (°F)",
     main = "Temperature in DC in August 2022 with 
     Average Temp based on Weather Condition")
# add line for average temp of clear weather days
abline(h=conditions_means$mean[1], lwd = "2", col = "red")
# add line for average temp of partially cloudy weather days
abline(h=conditions_means$mean[2], lwd = "2", col = "gray")
# add line for average temp of rain, overcast cloudy weather days
abline(h=conditions_means$mean[3], lwd = "2", col = "blue")
# add line for average temp of rain, partially cloudy weather days
abline(h=conditions_means$mean[4], lwd = "2", col = "orange")

legend("topright", c("Partially Cloudy", "Rain, Partially Cloudy", 
                     "Clear", "Rain, Overcast"),
                     col = c("gray", "orange", "red", "blue"), 
       cex = 0.7, lty = 1)

