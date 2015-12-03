# ECE6607
# Correlation of three weather stations
# Arthor: bitmingw
# Created: 2 Dec 2015
# Updated: 3 Dec 2015

# Execute the file by typing
# `source("weather_cor_analysis.R", print.eval = TRUE)`
# In R console

# Define Global Variables
MOV_AVG_WINDOW <- 30
TEMP_QUANTILE <- 0.98
RAIN_QUANTILE <- 0.90

# Define helper functions
ma <- function(x, n) {filter(x, rep(1/n, n), sides=2)}

# Running controller
SHOW_WIND_COR <- FALSE
SHOW_TIME_DIFF_PLOT <- TRUE
SHOW_MOV_AVG <- TRUE
SHOW_BAD_WEATHER_TIME <- TRUE
SHOW_STATION_COR <- TRUE
SHOW_TIME_DELAY <- TRUE

# Names of variables (Time is introduced by us)
#  [1] "Sample.Date"               "Sample.Time"              
#  [3] "TEMPERATURE"               "WIND_CHILL"               
#  [5] "HEAT_INDEX"                "DEW_POINT"                
#  [7] "DEGREE_DAY"                "DENSITY_ALTITUDE"         
#  [9] "AVG_TEMP_TODAY"            "WET_BULB_GLOBE_TEMP"      
# [11] "SAT_VAPOR_PRESSURE"        "VAPOR_PRESSURE"           
# [13] "DRY_AIR_PRESSURE"          "DRY_AIR_DENSITY"          
# [15] "ABSOLUTE_HUMIDITY"         "AIR_DENSITY_RATIO"        
# [17] "ADJUSTED_ALTITUDE"         "SAE_CORRECTION_FACTOR"    
# [19] "WET_AIR_DENSITY"           "WET_BULB_TEMPERATURE"     
# [21] "REL_HUMIDITY"              "WIND_SPEED_AV"            
# [23] "WIND_SPEED_MX"             "WIND_SPEED_MN"            
# [25] "RAW_WIND_DIR"              "RAW_WIND_DIR_AV"          
# [27] "RAW_WIND_DIR_MX"           "RAW_WIND_DIR_MN"          
# [29] "SEC3_ROLL_AVG_WIND_SPEED"  "SEC3_ROLL_AVG_WIND_DIR"   
# [31] "MIN2_ROLL_AVG_WIND_SPEED"  "MIN2_ROLL_AVG_WIND_DIR"   
# [33] "MIN10_ROLL_AVG_WIND_SPEED" "MIN10_ROLL_AVG_WIND_DIR"  
# [35] "MIN60_WIND_GUST_DIR"       "MIN60_WIND_GUST_SPEED"    
# [37] "MIN10_WIND_GUST_DIR"       "MIN10_WIND_GUST_SPEED"    
# [39] "RAIN_TODAY"                "RAINT_THIS_WEEK"          
# [41] "RAINT_THIS_MONTH"          "RAINT_THIS_YEAR"          
# [43] "RAIN_RATE"                 "RAIN_LAST_HR"             
# [45] "PRECIP_TYPE"               "RAW_BAROM_PRESS"          
# [47] "ADJ_BAROM_PRESS"           "Time" 

# Load libraries
library(ggplot2)
#library(caTools)
library(reshape) # don't use reshape2 since it has bug for melt function

# Assume the data and the script are in the working directory
data_Le <- read.csv("Lexington+weather+10-29-15.csv", stringsAsFactors = FALSE)
data_Marl <- read.csv("Marlboro+weather+10-29-15.csv", stringsAsFactors = FALSE)
data_Pough <- read.csv("Poughkeepsie+weather+10-29-15.csv", stringsAsFactors = FALSE)

# Convert time string to POSIX time
data_Le$Time <- strptime(paste(data_Le$Sample.Date, data_Le$Sample.Time),
    "%m/%d/%Y %H:%M:%S")
data_Marl$Time <- strptime(paste(data_Marl$Sample.Date, data_Marl$Sample.Time),
    "%m/%d/%Y %H:%M:%S")
data_Pough$Time <- strptime(paste(data_Pough$Sample.Date, data_Pough$Sample.Time),
    "%m/%d/%Y %H:%M:%S")

###############################################################################

# Task0: show the correlation among several rain / wind variables

# RAIN_RATE and RAIN_LAST_HR have exactly the same trend
# Have no idea what RAIN_TODAY RAINT_THIS_WEEK RAINT_THIS_MONTH etc.
l.diff.time <- data_Le$Time
if (SHOW_WIND_COR) {
l.wind.avg.speed <- data_Le$WIND_SPEED_AV
l.wind.sec3.speed <- data_Le$SEC3_ROLL_AVG_WIND_SPEED
l.wind.min2.speed <- data_Le$MIN2_ROLL_AVG_WIND_SPEED
l.wind.min10.speed <- data_Le$MIN10_ROLL_AVG_WIND_SPEED
l.wind.min10.gust.speed <- data_Le$MIN10_WIND_GUST_SPEED
l.wind.min60.gust.speed <- data_Le$MIN60_WIND_GUST_SPEED
l.wind.speed <- data.frame(l.diff.time, l.wind.avg.speed, l.wind.sec3.speed, l.wind.min2.speed,
    l.wind.min10.speed, l.wind.min10.gust.speed, l.wind.min60.gust.speed)
l.wind.melt <- melt(l.wind.speed, id.vars = c("l.diff.time"))
l.wind.plot <- ggplot(l.wind.melt, aes(x = l.diff.time, y = value, color = variable)) + geom_line()
plot(l.wind.plot)
dev.new()
# Conclusion: time interval of average is in (3 sec, 2 min)
# sec3, avg, min2, min10 has exactly the same trend
# gust10 and gust60 has much higher value than average (indicate max wind speed)
} # SHOW_WIND_COR

###############################################################################

# Task1: explore the variables using the data from Lexington weather station

# Potential logic fault: if using normalized difference, the absolute values
# are not shown. We may want to see severe weather by looking at the distribution
if (SHOW_TIME_DIFF_PLOT) {
l.diff.temp <- c(0, data_Le$TEMPERATURE[2:nrow(data_Le)] - data_Le$TEMPERATURE[1:nrow(data_Le)-1])
l.diff.temp <- l.diff.temp / max(abs(l.diff.temp))
l.diff.vapor.press <- c(0, data_Le$VAPOR_PRESSURE[2:nrow(data_Le)] - data_Le$VAPOR_PRESSURE[1:nrow(data_Le)-1])
l.diff.vapor.press <- l.diff.vapor.press / max(abs(l.diff.vapor.press))
l.diff.dry.press <- c(0, data_Le$DRY_AIR_PRESSURE[2:nrow(data_Le)] - data_Le$DRY_AIR_PRESSURE[1:nrow(data_Le)-1])
l.diff.dry.press <- l.diff.dry.press / max(abs(l.diff.dry.press))
l.diff.wet.density <- c(0, data_Le$WET_AIR_DENSITY[2:nrow(data_Le)] - data_Le$WET_AIR_DENSITY[1:nrow(data_Le)-1])
l.diff.wet.density <- l.diff.wet.density / max(abs(l.diff.wet.density))
l.diff.wind.speed <- c(0, data_Le$WIND_SPEED_AV[2:nrow(data_Le)] - data_Le$WIND_SPEED_AV[1:nrow(data_Le)-1])
l.diff.wind.speed <- l.diff.wind.speed / max(abs(l.diff.wind.speed))
# l.diff.wind.dir <- c(0, data_Le$RAW_WIND_DIR_AV[2:nrow(data_Le)] - data_Le$RAW_WIND_DIR_AV[1:nrow(data_Le)-1])
l.diff.rain.rate <- c(0, data_Le$RAIN_RATE[2:nrow(data_Le)] - data_Le$RAIN_RATE[1:nrow(data_Le)-1])
l.diff.rain.rate <- l.diff.rain.rate / max(abs(l.diff.rain.rate))

# l.diff.wind.speed temporarily removed since it is not stable...
l.diff.data <- data.frame(l.diff.time, l.diff.temp, l.diff.vapor.press,
    l.diff.dry.press, l.diff.wet.density, l.diff.rain.rate)

l.diff.melt <- melt(l.diff.data, id.vars = c("l.diff.time"))
l.diff.plot <- ggplot(l.diff.melt, aes(x = l.diff.time, y = value, color = variable)) + geom_line()
plot(l.diff.plot) # This plot illustrate the instance change of values at some time for all those major variables
dev.new()
} # SHOW_TIME_DIFF_PLOT

if (SHOW_MOV_AVG) {
if (MOV_AVG_WINDOW %% 2) {
    LEADING_ZEROS <- floor(MOV_AVG_WINDOW / 2)
    TRAILING_ZEROS <- floor(MOV_AVG_WINDOW / 2)
} else {
    LEADING_ZEROS <- MOV_AVG_WINDOW / 2 - 1
    TRAILING_ZEROS <- MOV_AVG_WINDOW / 2
}
l.diff.temp <- abs(c(rep(0, LEADING_ZEROS), l.diff.temp, rep(0, TRAILING_ZEROS)))
l.diff.vapor.press <- abs(c(rep(0, LEADING_ZEROS), l.diff.vapor.press, rep(0, TRAILING_ZEROS)))
l.diff.dry.press <- abs(c(rep(0, LEADING_ZEROS), l.diff.dry.press, rep(0, TRAILING_ZEROS)))
l.diff.wet.density <- abs(c(rep(0, LEADING_ZEROS), l.diff.wet.density, rep(0, TRAILING_ZEROS)))
l.diff.wind.speed <- abs(c(rep(0, LEADING_ZEROS), l.diff.wind.speed, rep(0, TRAILING_ZEROS)))
l.diff.rain.rate <- abs(c(rep(0, LEADING_ZEROS), l.diff.rain.rate, rep(0, TRAILING_ZEROS)))
l.avg.diff.temp <- as.vector(ma(l.diff.temp, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
l.avg.diff.vapor.press <- as.vector(ma(l.diff.vapor.press, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
l.avg.diff.dry.press <- as.vector(ma(l.diff.dry.press, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
l.avg.diff.wet.density <- as.vector(ma(l.diff.wet.density, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
l.avg.diff.wind.speed <- as.vector(ma(l.diff.wind.speed, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
l.avg.diff.rain.rate <- as.vector(ma(l.diff.rain.rate, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]

# l.diff.wind.speed temporarily removed since it is not stable...
l.avg.diff.data <- data.frame(l.diff.time, l.avg.diff.temp, l.avg.diff.vapor.press,
    l.avg.diff.dry.press, l.avg.diff.wet.density, l.avg.diff.rain.rate)
l.avg.diff.melt <- melt(l.avg.diff.data, id.vars = c("l.diff.time"))
l.avg.diff.plot <- ggplot(l.avg.diff.melt, aes(x = l.diff.time, y = value, color = variable)) + geom_line()
plot(l.avg.diff.plot) # This plot illustrate the moving average change of values for all those major variables
dev.new()
} # SHOW_MOV_AVG

if (SHOW_BAD_WEATHER_TIME) {
l.avg.diff.data.notime <- data.frame(l.avg.diff.temp, l.avg.diff.vapor.press,
    l.avg.diff.dry.press, l.avg.diff.wet.density, l.avg.diff.rain.rate)
cor(l.avg.diff.data.notime)
# Conclusion: the difference of temperature and wet are density has very strong correlation
# We may use temperature to identify severe weather

# Histogram of temperature difference
l.avg.diff.temp.hist <- ggplot(data.frame(l.avg.diff.temp), aes(l.avg.diff.temp)) + geom_histogram(binwidth = 0.01, col = "red", fill = "yellow")
plot(l.avg.diff.temp.hist)
dev.new()
# It is not appropriate to used 3*sigma since it is not normal distribution
# From intuition we can set quantile = 0.98 to get the threshold
l.bad.weather.temp.thres <- quantile(l.avg.diff.temp, TEMP_QUANTILE)
l.bad.weather.temp <- l.avg.diff.temp > l.bad.weather.temp.thres

# Usually a severe weather is accompanied with raining, let's exam that!
# NOTE: it only works when most of time it is not raining
l.avg.diff.rain.rate.hist <- ggplot(data.frame(l.avg.diff.rain.rate), aes(l.avg.diff.rain.rate)) + geom_histogram(binwidth = 0.01, col = "red", fill = "yellow")
plot(l.avg.diff.rain.rate.hist)
dev.new()
l.bad.weather.rain.thres <- quantile(l.avg.diff.rain.rate, RAIN_QUANTILE)
l.bad.weather.rain <- l.avg.diff.rain.rate > l.bad.weather.rain.thres
table(l.bad.weather.temp, l.bad.weather.rain)
# Conclusion: use the combination of temperature change and rain rate to determine severe weather

# Determine the time slice of severe weather
l.bad.weather <- l.bad.weather.temp & l.bad.weather.rain
l.now.bad.weather = FALSE
l.bad.weather.start.time <- c()
l.bad.weather.end.time <- c()
for (i in 1:length(l.bad.weather.temp)) {
    if (l.bad.weather[i] && (!l.now.bad.weather)) {
        l.now.bad.weather <- TRUE
        l.bad.weather.start.time <- c(l.bad.weather.start.time, strftime(l.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    } else if (!l.bad.weather[i] && l.now.bad.weather) {
        l.now.bad.weather <- FALSE
        l.bad.weather.end.time <- c(l.bad.weather.end.time, strftime(l.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    }
}
} # SHOW_BAD_WEATHER_TIME

###############################################################################

# Task3: reveal the relationship among several weather stations
if (SHOW_STATION_COR) {
l.temp.data <- data.frame(Time = data_Le$Time, Temp = data_Le$TEMPERATURE)
m.temp.data <- data.frame(Time = data_Marl$Time, Temp = data_Marl$TEMPERATURE)
p.temp.data <- data.frame(Time = data_Pough$Time, Temp = data_Pough$TEMPERATURE)
temp.plot <- ggplot() + geom_line(data = l.temp.data, aes(x = Time, y = Temp, color = "red")) +
    geom_line(data = m.temp.data, aes(x = Time, y = Temp, color = "green")) +
    geom_line(data = p.temp.data, aes(x = Time, y = Temp, color = "blue"))
plot(temp.plot)
dev.new()
# It seems that red and green are more correlated to each other
cor(data_Le$TEMPERATURE, data_Marl$TEMPERATURE[1:2877])
cor(data_Le$TEMPERATURE, data_Pough$TEMPERATURE[1:2877])
cor(data_Marl$TEMPERATURE, data_Pough$TEMPERATURE)
# We can't just simple by looking at the correlation
} # SHOW_STATION_COR

###############################################################################

# Task4: find the time delay for severe weather condition
if (SHOW_TIME_DELAY) {
# Do analysis for Marlboro
m.diff.time <- data_Marl$Time
m.diff.temp <- c(0, data_Marl$TEMPERATURE[2:nrow(data_Marl)] - data_Marl$TEMPERATURE[1:nrow(data_Marl)-1])
m.diff.temp <- m.diff.temp / max(abs(m.diff.temp))
m.diff.rain.rate <- c(0, data_Marl$RAIN_RATE[2:nrow(data_Marl)] - data_Marl$RAIN_RATE[1:nrow(data_Marl)-1])
m.diff.rain.rate <- m.diff.rain.rate / max(abs(m.diff.rain.rate))
m.diff.temp <- abs(c(rep(0, LEADING_ZEROS), m.diff.temp, rep(0, TRAILING_ZEROS)))
m.avg.diff.temp <- as.vector(ma(m.diff.temp, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Marl))]
m.diff.rain.rate <- abs(c(rep(0, LEADING_ZEROS), m.diff.rain.rate, rep(0, TRAILING_ZEROS)))
m.avg.diff.rain.rate <- as.vector(ma(m.diff.rain.rate, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Marl))]
m.bad.weather.temp.thres <- quantile(m.avg.diff.temp, TEMP_QUANTILE)
m.bad.weather.temp <- m.avg.diff.temp > m.bad.weather.temp.thres
m.bad.weather.rain.thres <- quantile(m.avg.diff.rain.rate, RAIN_QUANTILE)
m.bad.weather.rain <- m.avg.diff.rain.rate > m.bad.weather.rain.thres
m.bad.weather <- m.bad.weather.temp & m.bad.weather.rain
m.now.bad.weather = FALSE
m.bad.weather.start.time <- c()
m.bad.weather.end.time <- c()
for (i in 1:length(m.bad.weather.temp)) {
    if (m.bad.weather[i] && (!m.now.bad.weather)) {
        m.now.bad.weather <- TRUE
        m.bad.weather.start.time <- c(m.bad.weather.start.time, strftime(m.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    } else if (!m.bad.weather[i] && m.now.bad.weather) {
        m.now.bad.weather <- FALSE
        m.bad.weather.end.time <- c(m.bad.weather.end.time, strftime(m.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    }
}
# Do analysis for Poughkeepsie
p.diff.time <- data_Pough$Time
p.diff.temp <- c(0, data_Pough$TEMPERATURE[2:nrow(data_Pough)] - data_Pough$TEMPERATURE[1:nrow(data_Pough)-1])
p.diff.temp <- p.diff.temp / max(abs(p.diff.temp))
p.diff.rain.rate <- c(0, data_Pough$RAIN_RATE[2:nrow(data_Pough)] - data_Pough$RAIN_RATE[1:nrow(data_Pough)-1])
p.diff.rain.rate <- p.diff.rain.rate / max(abs(p.diff.rain.rate))
p.diff.temp <- abs(c(rep(0, LEADING_ZEROS), p.diff.temp, rep(0, TRAILING_ZEROS)))
p.avg.diff.temp <- as.vector(ma(p.diff.temp, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Pough))]
p.diff.rain.rate <- abs(c(rep(0, LEADING_ZEROS), p.diff.rain.rate, rep(0, TRAILING_ZEROS)))
p.avg.diff.rain.rate <- as.vector(ma(p.diff.rain.rate, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Pough))]
p.bad.weather.temp.thres <- quantile(p.avg.diff.temp, TEMP_QUANTILE)
p.bad.weather.temp <- p.avg.diff.temp > m.bad.weather.temp.thres
p.bad.weather.rain.thres <- quantile(p.avg.diff.rain.rate, RAIN_QUANTILE)
p.bad.weather.rain <- p.avg.diff.rain.rate > p.bad.weather.rain.thres
p.bad.weather <- p.bad.weather.temp & p.bad.weather.rain
p.now.bad.weather = FALSE
p.bad.weather.start.time <- c()
p.bad.weather.end.time <- c()
for (i in 1:length(p.bad.weather.temp)) {
    if (p.bad.weather[i] && (!p.now.bad.weather)) {
        p.now.bad.weather <- TRUE
        p.bad.weather.start.time <- c(p.bad.weather.start.time, strftime(p.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    } else if (!p.bad.weather[i] && p.now.bad.weather) {
        p.now.bad.weather <- FALSE
        p.bad.weather.end.time <- c(p.bad.weather.end.time, strftime(p.diff.time[i], "%m/%d/%Y %H:%M:%S"))
    }
}
# Combine the results of three stations
l.bad.time <- data.frame(Time = data_Le$Time, Bad.Weather = as.numeric(l.bad.weather))
m.bad.time <- data.frame(Time = data_Marl$Time, Bad.Weather = as.numeric(m.bad.weather))
p.bad.time <- data.frame(Time = data_Pough$Time, Bad.Weather = as.numeric(p.bad.weather))
bad.time.plot <- ggplot(aes()) + geom_line(data = l.bad.time, aes(x = Time, y = Bad.Weather, color = "red")) +
    geom_line(data = m.bad.time, aes(x = Time, y = Bad.Weather, color = "green")) +
    geom_line(data = p.bad.time, aes(x = Time, y = Bad.Weather, color = "blue"))
plot(bad.time.plot)
} # SHOW_TIME_DELAY


