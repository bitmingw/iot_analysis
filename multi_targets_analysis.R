# ECE6607
# Correlation of three weather stations
# Arthor: bitmingw
# Created: 2 Dec 2015
# Updated: 2 Dec 2015

# Execute the file by typing
# `source("weather_cor_analysis.R", print.eval = TRUE)`
# In R console

# Define Global Variables
MOV_AVG_WINDOW = 30

# Define helper functions
ma <- function(x, n) {filter(x, rep(1/n, n), sides=2)}

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

# TODO:
# 1. Find the time of severe weather by gather differential of major variables
#    Proposed major variables that indicate severe weather:
#    TEMPERATURE, VAPOR_PRESSURE, DRY_AIR_PRESSURE, WET_AIR_DENSITY,
#    WIND_SPEED_AV, RAW_WIND_DIR_AV, RAIN_RATE
#    Note: need to justify each variable (intuitively)
#          need to reveal the correlation among a lot of WIND and RAIN variables
# 2. Find the correlation of weather between stations use the variables above
# 3. If there is a strong relationship, try find the time delay of
#    the same event on different weather stations
# 4. Reverse engineering: get the trend of evolution

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
diff.time <- data_Le$Time
wind.avg.speed <- data_Le$WIND_SPEED_AV
wind.sec3.speed <- data_Le$SEC3_ROLL_AVG_WIND_SPEED
wind.min2.speed <- data_Le$MIN2_ROLL_AVG_WIND_SPEED
wind.min10.speed <- data_Le$MIN10_ROLL_AVG_WIND_SPEED
wind.min10.gust.speed <- data_Le$MIN10_WIND_GUST_SPEED
wind.min60.gust.speed <- data_Le$MIN60_WIND_GUST_SPEED
wind.speed <- data.frame(diff.time, wind.avg.speed, wind.sec3.speed, wind.min2.speed,
    wind.min10.speed, wind.min10.gust.speed, wind.min60.gust.speed)
wind.melt <- melt(wind.speed, id.vars = c("diff.time"))
wind.plot <- ggplot(wind.melt, aes(x = diff.time, y = value, color = variable)) + geom_line()
#wind.plot
# Conclusion: time interval of average is in (3 sec, 2 min)
# sec3, avg, min2, min10 has exactly the same trend
# gust10 and gust60 has much higher value than average (indicate max wind speed)

###############################################################################

# Task1: explore the variables using the data from Lexington weather station

diff.temp <- c(0, data_Le$TEMPERATURE[2:nrow(data_Le)] - data_Le$TEMPERATURE[1:nrow(data_Le)-1])
diff.temp <- diff.temp / max(abs(diff.temp))
diff.vapor.press <- c(0, data_Le$VAPOR_PRESSURE[2:nrow(data_Le)] - data_Le$VAPOR_PRESSURE[1:nrow(data_Le)-1])
diff.vapor.press <- diff.vapor.press / max(abs(diff.vapor.press))
diff.dry.press <- c(0, data_Le$DRY_AIR_PRESSURE[2:nrow(data_Le)] - data_Le$DRY_AIR_PRESSURE[1:nrow(data_Le)-1])
diff.dry.press <- diff.dry.press / max(abs(diff.dry.press))
diff.wet.density <- c(0, data_Le$WET_AIR_DENSITY[2:nrow(data_Le)] - data_Le$WET_AIR_DENSITY[1:nrow(data_Le)-1])
diff.wet.density <- diff.wet.density / max(abs(diff.wet.density))
diff.wind.speed <- c(0, data_Le$WIND_SPEED_AV[2:nrow(data_Le)] - data_Le$WIND_SPEED_AV[1:nrow(data_Le)-1])
diff.wind.speed <- diff.wind.speed / max(abs(diff.wind.speed))
# diff.wind.dir <- c(0, data_Le$RAW_WIND_DIR_AV[2:nrow(data_Le)] - data_Le$RAW_WIND_DIR_AV[1:nrow(data_Le)-1])
diff.rain.rate <- c(0, data_Le$RAIN_RATE[2:nrow(data_Le)] - data_Le$RAIN_RATE[1:nrow(data_Le)-1])
diff.rain.rate <- diff.rain.rate / max(abs(diff.rain.rate))

# diff.wind.speed temporarily removed since it is not stable...
diff.data <- data.frame(diff.time, diff.temp, diff.vapor.press,
    diff.dry.press, diff.wet.density, diff.rain.rate)

diff.melt <- melt(diff.data, id.vars = c("diff.time"))
diff.plot <- ggplot(diff.melt, aes(x = diff.time, y = value, color = variable)) + geom_line()
#diff.plot # This plot illustrate the instance change of values at some time for all those major variables


if (MOV_AVG_WINDOW %% 2) {
    LEADING_ZEROS <- floor(MOV_AVG_WINDOW / 2)
    TRAILING_ZEROS <- floor(MOV_AVG_WINDOW / 2)
} else {
    LEADING_ZEROS <- MOV_AVG_WINDOW / 2 - 1
    TRAILING_ZEROS <- MOV_AVG_WINDOW / 2
}
diff.temp <- abs(c(rep(0, LEADING_ZEROS), diff.temp, rep(0, TRAILING_ZEROS)))
diff.vapor.press <- abs(c(rep(0, LEADING_ZEROS), diff.vapor.press, rep(0, TRAILING_ZEROS)))
diff.dry.press <- abs(c(rep(0, LEADING_ZEROS), diff.dry.press, rep(0, TRAILING_ZEROS)))
diff.wet.density <- abs(c(rep(0, LEADING_ZEROS), diff.wet.density, rep(0, TRAILING_ZEROS)))
diff.wind.speed <- abs(c(rep(0, LEADING_ZEROS), diff.wind.speed, rep(0, TRAILING_ZEROS)))
diff.rain.rate <- abs(c(rep(0, LEADING_ZEROS), diff.rain.rate, rep(0, TRAILING_ZEROS)))
avg.diff.temp <- as.vector(ma(diff.temp, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
avg.diff.vapor.press <- as.vector(ma(diff.vapor.press, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
avg.diff.dry.press <- as.vector(ma(diff.dry.press, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
avg.diff.wet.density <- as.vector(ma(diff.wet.density, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
avg.diff.wind.speed <- as.vector(ma(diff.wind.speed, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]
avg.diff.rain.rate <- as.vector(ma(diff.rain.rate, MOV_AVG_WINDOW))[(LEADING_ZEROS+1):(LEADING_ZEROS+nrow(data_Le))]

# diff.wind.speed temporarily removed since it is not stable...
avg.diff.data <- data.frame(diff.time, avg.diff.temp, avg.diff.vapor.press,
    avg.diff.dry.press, avg.diff.wet.density, avg.diff.rain.rate)
avg.diff.melt <- melt(avg.diff.data, id.vars = c("diff.time"))
avg.diff.plot <- ggplot(avg.diff.melt, aes(x = diff.time, y = value, color = variable)) + geom_line()
#avg.diff.plot # This plot illustrate the moving average change of values for all those major variables
