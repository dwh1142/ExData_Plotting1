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

par(cex.axis = 0.9, cex.lab = 0.9)

with(twoDay, plot(Global_active_power~datetime, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))

dev.print(device = png, file = "plot2.png", width = 480, height = 480, units = "px")
