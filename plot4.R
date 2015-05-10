#set the working directory as well as the downloaded file position
setwd("C:\\Users\\lenovo\\workspace\\Exploratory_data_analysis")
myfile <- "household_power_consumption.txt"

#load libraries intend to use for analysis
library(data.table)
library(sqldf)
library(dplyr)

#read data file using SQL to avoid load all data at once
fcon <- file(myfile)
SQLDF <- sqldf("SELECT * 
               FROM fcon 
               WHERE Date = '1/2/2007'OR Date = '2/2/2007'", 
               dbname = tempfile(), 
               file.format = list(header = T, row.names = F, sep =";"))
close(fcon)
#take a look at the data structure
str(SQLDF)
#copy the data to a differen variable so we don't need to read the file again
db <-SQLDF
#create a new column to combine the Data and Time 
db <- mutate(db, DateTime = paste(Date, Time))
#covert the DateTime column to R Time structure
db$DateTime <- strptime(db$DateTime, format = "%d/%m/%Y %H:%M:%S")
#drop the old data and time column
db <- select(db, -c(Date, Time))
#verify result
str(db)

#set the device
png("Plot4.png", bg="white")
#set the mulitple plot device format
par(mfrow = c(2,2))
#plot the first graph on the (1,1)
plot(db$DateTime, db$Global_active_power, type = 'l', ylab = "Global Active Power",
     xlab ="")
#plot the 2nd graph on the (1,2)
plot(db$DateTime, db$Voltage, type = 'l', ylab = "Voltage",
     xlab ="datetime")
#plot the 3rd graph on the (2,1)
plot(db$DateTime, db$Sub_metering_1, type = 'l', ylab = "Energy sub metering", 
     xlab = "")
#add lines and legend
lines(db$DateTime, db$Sub_metering_2, type = 'l', col = 'red')
lines(db$DateTime, db$Sub_metering_3, type = 'l', col = 'blue')
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1), col= c("black","red","blue"), bty = "n")
#plot the 4th graph on the (2,2)
plot(db$DateTime, db$Global_reactive_power, type = 'l', ylab = "Global_reactive_power",
     xlab ="datetime")
dev.off()