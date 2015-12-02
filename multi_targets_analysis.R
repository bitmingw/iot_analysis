# ECE6607
# Correlation of three weather stations
# Arthor: bitmingw
# Created: 2 Dec 2015
# Updated: 2 Dec 2015

# Execute the file by typing
# `source("weather_cor_analysis.R", print.eval = TRUE)`
# In R console

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
#    WIND_SPEED_AV, RAW_WIND_DIR, RAIN_LAST_HR?
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
data_Le$Time <- strptime(paste(data_Le$Sample.Date, data_Le$Sample.Time), "%m/%d/%Y %H:%M:%S")
data_Marl$Time <- strptime(paste(data_Marl$Sample.Date, data_Marl$Sample.Time), "%m/%d/%Y %H:%M:%S")
data_Pough$Time <- strptime(paste(data_Pough$Sample.Date, data_Pough$Sample.Time), "%m/%d/%Y %H:%M:%S")
