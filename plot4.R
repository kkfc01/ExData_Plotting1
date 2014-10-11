#Start by reading the first 5 lines to get an idea what the data is like
temp.read <- read.table("household_power_consumption.txt", header = T, sep = ";", nrows = 5)

#Each row is one minute increment and starts at 16/12/2006 17:24:00
#Grab the date and time of the first row of the temp.read and put it into a POSTIXlt class
FirstRow <- paste(temp.read[[1]], temp.read[[2]])
FirstRowDT <- strptime(FirstRow, "%d/%m/%Y %H:%M:%S")

#This is the starting date and time that we are interested
Begin <- c("2007-02-01 00:00:00")
BeginDT <- strptime(Begin, "%Y-%m-%d %H:%M:%S")

#The difference in minutes is the number of rows we need to skip before reading the data
skip.rows <- trunc(difftime(BeginDT, FirstRowDT, units = "mins"), digits = 0)

#This is the end date and time that we are interested
End <- c("2007-02-02 23:59:59")
EndDT <- strptime(End, "%Y-%m-%d %H:%M:%S")

#The difference in minutes is the number of rows to read into the data table.
read.rows <- trunc(difftime(EndDT, BeginDT, units = "mins"), digits = 0)

#Read the data into the data table
data.read <- read.table("household_power_consumption.txt", header = T, sep = ";",
                        col.names = names(temp.read), nrows = read.rows, skip = skip.rows)

#Join the Date and Time column by using the paste function
JoinDT <- paste(data.read$Date, data.read$Time)
DT <- strptime(JoinDT, "%d/%m/%Y %H:%M:%S")

#Plot the graphs
png("plot4.png", width=480, height=480)
par(mfcol = c(2,2))
plot(DT, data.read$Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)")

plot(DT, data.read$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(DT, data.read$Sub_metering_2, col = 'red')
lines(DT, data.read$Sub_metering_3, col = 'blue')
legend("topright", legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1,1), col=c("black","red","blue"), bty = "n")

plot(DT, data.read$Voltage, type = "l", xlab = "datetime", ylab = 'Voltage')

plot(DT, data.read$Global_reactive_power, type = "l", xlab = "datetime", ylab = 'Global_reactive_power')
dev.off()
