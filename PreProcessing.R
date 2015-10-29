# ECE6607
# Processing the weather station data with R
# Arthor: bitmingw
# Created: 29 Oct 2015
# Updated: 29 Oct 2015

# Execute the file by typing
# `source("PreProcessing.R", print.eval = TRUE)`
# In R console

# Load libraries
library(ggplot2)

# Assume the data and the script are in the working directory
data <- read.csv("data2.csv", stringsAsFactors = FALSE)

# Convert time string to POSIX time
data$Sample.Time <- paste("2015-08-13", data$Sample.Time)
data$Time <- strptime(data$Sample.Time, "%Y-%m-%d %H:%M:%S")

# Draw a plot about the temperature vs time
ggplot(data, aes(Time, Temperature)) + geom_line() + labs(title = "Temperature in One Day")
