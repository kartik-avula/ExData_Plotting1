# JHU Data Science - Course 04 - Exploratory Data Analysis - Assignment1 - Plot1

library(dplyr)


################################ Download data ################################
UCIPowerDataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("household_power_consumption.txt")) {
    if(!file.exists("UCIPowerData.zip")) {
        download.file(UCIPowerDataURL,destfile = "UCIPowerData.zip",method = "curl")
    }
    unzip("UCIPowerData.zip")
}

################################## Read data ##################################

# Set timezone. The link below clearly shows that the data is from a household
# near Paris/France. Hence setting timezone to CET. However, I believe the 
# graphics in the Course project descriptions seem to be made with ET. For
# Exact replica we can set data_tz to ET
# https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
data_tz = "CET"

# Set column classes based on README / Codebook
var_classes <- c("character", "character", rep("numeric",7))
household_power_consumption <- read.csv("household_power_consumption.txt",
                                        na.strings = "?", sep = ";", colClasses = var_classes)

# Converts and combines Date and Time character columns to a new, single POSIXct var called datetime
household_power_consumption$datetime <- 
    with(household_power_consumption, 
         as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S", tz = data_tz))

# Keep the rows you need in a new variable 
required_dates <- as.Date(c("2007-02-01","2007-02-02"), format = "%Y-%m-%d", tz = data_tz)
stripped_power_data <- filter(household_power_consumption,as.Date(datetime) %in% required_dates)
rm("household_power_consumption")

################################## Plot data ##################################

png(filename = "Rplot1.png")

with(stripped_power_data, hist(Global_active_power, col = "red", main = "Global Active Power", 
                               xlab = "Global Active Power (kilowatts)", ylab = "Frequency"))
# Close png device 
dev.off(dev.cur())

# [OPTIONAL]
# Code below if you don't want to specify annotations in hist call 
# with(stripped_power_data, hist(Global_active_power, col = "red", main = NULL, xlab = NULL, ylab = NULL))
# title(main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
# Note that for plot the "xlab = NULL" does not work. Needs xlab = ""