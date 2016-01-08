library(dplyr)
library(lubridate)
library(ggplot2)

#set download url
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#function to download a zipped file and unzip it into working directory
downloadUnzip <- function(fileUrl) {
  download.file(fileUrl, "./data.zip")
  unzip("./data.zip")
}

if(!file.exists("./data.zip")) {downloadUnzip(fileUrl)}


consumptionData <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", stringsAsFactors = FALSE, header = TRUE)

consumptionData <- consumptionData %>% 
  mutate(Date = dmy(Date))

twoDay <- consumptionData %>%
  filter(as.character(Date) == "2007-02-01" | as.character(Date) == "2007-02-02") %>%
  mutate(datetime = ymd_hms(paste(Date, Time)))

par(cex.lab = 0.9, cex.axis = 0.9)

with(twoDay, plot(Global_active_power~datetime, type = "l", xlab = "", ylab = "Global Active Power"))

with(twoDay, plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(twoDay, lines(datetime, Sub_metering_2, col = "red"))
with(twoDay, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), col = c("black", "red", "blue"), pt.cex = 1, cex = 0.9)


#Depending on the size of your default device (e.g. R Studio plot window), the legend text could get cut-off when printed to png. 
#Need to resize default device window before printing to png to ensure legend fits correctly
dev.print(device = png, file = "plot3.png", width = 480, height = 480, units = "px")
