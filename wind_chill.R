# ECE6607
# Apply Wind.Chill models to more weather stations
# Arthor: bitmingw
# Created: 5 Dec 2015
# Updated: 5 Dec 2015

# Execute the file by typing
# `source("wind_chill.R", print.eval = TRUE)`
# In R console

library(ggplot2)
library(caTools)
library(reshape)

# Load first file
wdata <- read.csv("data2.csv", stringsAsFactors = FALSE)
wdata$Sample.Time <- paste("2015-08-13", wdata$Sample.Time)
wdata$Time <- strptime(wdata$Sample.Time, "%Y-%m-%d %H:%M:%S")

# Load other files
data_Le <- read.csv("Lexington+weather+10-29-15.csv", stringsAsFactors = FALSE)
data_Marl <- read.csv("Marlboro+weather+10-29-15.csv", stringsAsFactors = FALSE)
data_Pough <- read.csv("Poughkeepsie+weather+10-29-15.csv", stringsAsFactors = FALSE)
data_Le$Time <- strptime(paste(data_Le$Sample.Date, data_Le$Sample.Time),
    "%m/%d/%Y %H:%M:%S")
data_Marl$Time <- strptime(paste(data_Marl$Sample.Date, data_Marl$Sample.Time),
    "%m/%d/%Y %H:%M:%S")
data_Pough$Time <- strptime(paste(data_Pough$Sample.Date, data_Pough$Sample.Time),
    "%m/%d/%Y %H:%M:%S")

# Rename the columns to match with the model
colnames(data_Le)[3] <- "Temperature"
colnames(data_Marl)[3] <- "Temperature"
colnames(data_Pough)[3] <- "Temperature"
colnames(data_Le)[4] <- "Wind.Chill"
colnames(data_Marl)[4] <- "Wind.Chill"
colnames(data_Pough)[4] <- "Wind.Chill"
colnames(data_Le)[22] <- "Avg.Wind.Speed"
colnames(data_Marl)[22] <- "Avg.Wind.Speed"
colnames(data_Pough)[22] <- "Avg.Wind.Speed"

# Split the data set into 2 parts
# This part closely follow the original `weather_cor_analysis.R` script
set.seed(6607)
split.vec <- sample.split(wdata[,1], 2/3)
train.set <- subset(wdata, split.vec)
test.set <- subset(wdata, !split.vec)

# Build linear model to explore the Wind.Chill variable
wind.chill.mod <- lm(Wind.Chill ~ Temperature + Avg.Wind.Speed, data = train.set)

# Do predict and plot
l.Wind.Chill <- predict(wind.chill.mod, newdata = data_Le)
m.Wind.Chill <- predict(wind.chill.mod, newdata = data_Marl)
p.Wind.Chill <- predict(wind.chill.mod, newdata = data_Pough)
l.Wind.Chill.data <- cbind(data_Le[c("Time", "Wind.Chill")], l.Wind.Chill)
m.Wind.Chill.data <- cbind(data_Marl[c("Time", "Wind.Chill")], m.Wind.Chill)
p.Wind.Chill.data <- cbind(data_Pough[c("Time", "Wind.Chill")], p.Wind.Chill)
l.Wind.Chill.melt <- melt(l.Wind.Chill.data, id.vars = "Time")
m.Wind.Chill.melt <- melt(m.Wind.Chill.data, id.vars = "Time")
p.Wind.Chill.melt <- melt(p.Wind.Chill.data, id.vars = "Time")
l.plot <- ggplot(l.Wind.Chill.melt, aes(x = Time, y = value, color = variable)) +
	geom_line() + labs(title = "Wind Chill model on Weather Station Lexington 20151029")
m.plot <- ggplot(m.Wind.Chill.melt, aes(x = Time, y = value, color = variable)) +
	geom_line() + labs(title = "Wind Chill model on Weather Station Marlboro 20151029")
p.plot <- ggplot(p.Wind.Chill.melt, aes(x = Time, y = value, color = variable)) +
	geom_line() + labs(title = "Wind Chill model on Weather Station Poughkeepsie 20151029")
l.plot
m.plot
p.plot
