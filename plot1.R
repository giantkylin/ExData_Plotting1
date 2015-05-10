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
png("Plot1.png", bg="white")
#plot
hist(db$Global_active_power,col="red",main="Global Active Power",
     xlab="Global Active Power (kilowatts)")
#dev.copy(png, "Plot1.png", bg="white")
dev.off()
