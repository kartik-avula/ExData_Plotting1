# JHU Data Science - Course 04 - Exploratory Data Analysis - Assignment1 - Plot3

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

png(filename = "Rplot3.png")


# Adjusting margins to ensure no cut off on the horizontal axis
par(mar = c(5.1, 4, 4.1, 1))
with(stripped_power_data, plot(datetime, Sub_metering_1, type= "n",
                               ylab = "Energy sub metering",
                               xlab = ""))
with(stripped_power_data, lines(datetime, Sub_metering_1, col = "black"))
with(stripped_power_data, lines(datetime, Sub_metering_2, col = "red"))
with(stripped_power_data, lines(datetime, Sub_metering_3, col = "blue"))

legend("topright", 
       legend = paste0("Sub_metering_",1:3), 
       lty = "solid", col = c("black", "red", "blue"))

# Close png device 
dev.off(dev.cur())
