# ECE 6607 Project
# Data Profiler
# Q.Ju
# Oct.22, 2015
# Test on ecelinsrvx.ece.gatech.edu

import csv
import sys
import time
import numpy as np
import matplotlib as mpl
mpl.use( 'Agg' )
import matplotlib.pyplot as plt
import os

f = open( sys.argv[1], 'r' )
f.next() # skip first header line
i = 0;




print "Reading src data file: %s "  % sys.argv[1]






#header
header_list = []


#time list in hour
time = []




#data 
t_list = []
temp_list = []
wind_chi = []
heat_idx = []
dew_point = []
deg_day = []
dens_alt = []
avg_temp_today = []
wet_bulb_glob_temp = []
sat_vap_pres = []
vap_pres = []
dry_air_pres = []
dry_air_den = []
abs_hum = []
air_den_rto = []
adj_alt = []
sae_cor_fac = []
wet_air_den = []
wet_bulb_tmp = []
rel_hum = []
avg_wind_spd = []
wind_spd_mx = []
wind_spd_mn = []
raw_wind_dir = []
raw_wind_dir_av = []
raw_wind_dir_mx = []
raw_wind_dir_mn = []
sec3_roll_avg_wind_spd = []
sec3_roll_avg_wind_dir = []
min2_roll_avg_wind_spd = []
min2_roll_avg_wind_dir = []
min10_roll_avg_wind_spd = []
min10_roll_avg_wind_dir = []
min60_wind_gust_dir = []
min60_wind_gust_spd = []
min10_wind_gust_dir = []
min10_wind_gust_spd = []
rain_tdy = []
rain_this_wk = []
rain_this_mth =[]
rain_this_yr = []
rain_rate = []
rain_last_hr = []
prec_type = []
raw_barom_pres = []
adj_barom_pres = []






try:
    reader = csv.reader(f)
    for row in reader:
	t_list.append( row[0] )
	temp_list.append( float(row[1]) )
	wind_chi.append( float(row[2]) )
	heat_idx.append( int(row[3]) )
	dew_point.append( float(row[4]) )
	deg_day.append( float(row[5]) )
	dens_alt.append( float(row[6]) )
	avg_temp_today.append( float(row[7]) )
	wet_bulb_glob_temp.append( float(row[8]) )
	sat_vap_pres.append( float(row[9]) )
	vap_pres.append( float(row[10]) )
	dry_air_pres.append( float(row[11]) )
	dry_air_den.append( float(row[12]) )
	abs_hum.append( float(row[13]) )
	air_den_rto.append( float(row[14]) )
	adj_alt.append( float(row[15]) )
	sae_cor_fac.append( float(row[16]) )
	wet_air_den.append( float(row[17]) )
	wet_bulb_tmp.append( float(row[18]) )
	rel_hum.append( float(row[19]) )
	avg_wind_spd.append( float(row[20]) )
	wind_spd_mx.append( float(row[21]) )
	wind_spd_mn.append( float(row[22]) )
	raw_wind_dir.append( float(row[23]) )
	raw_wind_dir_av.append( float(row[24]) )
	raw_wind_dir_mx.append( float(row[25]) )
	raw_wind_dir_mn.append( float(row[26]) )
	sec3_roll_avg_wind_spd.append( float(row[27]) )
	sec3_roll_avg_wind_dir.append( float(row[28]) )
	min2_roll_avg_wind_spd.append( float(row[29]) )
	min2_roll_avg_wind_dir.append( float(row[30]) )
	min10_roll_avg_wind_spd.append( float(row[31]) )
	min10_roll_avg_wind_dir.append( float(row[32]) )
	min60_wind_gust_dir.append( int(row[33]) )
	min60_wind_gust_spd.append( row[34] )
	min10_wind_gust_dir.append( int(row[35]) )
	min10_wind_gust_spd.append( row[36] )
	rain_tdy.append( int(row[37]) )
	rain_this_wk.append( float(row[38]) )
	rain_this_mth.append( float(row[39]) )
	rain_this_yr.append( float(row[40]) )
	rain_rate.append( int(row[41]) )
	rain_last_hr.append( int(row[42]) )
	prec_type.append( int(row[43]) )
	raw_barom_pres.append( float(row[44]) )
	adj_barom_pres.append( float(row[45]) )

	time.append(float(i)/float(60))






	#if i < 10:	
	#    print raw_wind_dir[i]

   	i = i + 1
finally:
    f.close()




print "Total Lines(header not included):  %d " % i

if not os.path.exists('figure'):
	os.makedirs('figure')


 
fig = plt.figure(figsize = (10,5))
plt.plot( time, temp_list )
fig.savefig('figure/temp_list.png')
plt.close(fig)
print "Figure for Temperature complete !"



fig = plt.figure(figsize = (10,5))
plt.plot( time, wind_chi )
fig.savefig('figure/wind_chi.png')
plt.close(fig)
print "Figure for Wind.Chill complete !"


fig = plt.figure(figsize = (10,5))
plt.plot( time, heat_idx )
fig.savefig('figure/heat_idx.png')
plt.close(fig)
print "Figure for heat_idx complete !"


fig = plt.figure(figsize = (10,5))
plt.plot( time, dew_point )
fig.savefig('figure/dew_point.png')
plt.close(fig)
print "Figure for dew_point complete !"


fig = plt.figure(figsize = (10,5))
plt.plot( time, deg_day )
fig.savefig('figure/degree_day.png')
plt.close(fig)
print "Figure for degree_day complete !"


fig = plt.figure(figsize = (10,5))
plt.plot( time, dens_alt )
fig.savefig('figure/density_altitude.png')
plt.close(fig)
print "Figure for density_altitude complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, avg_temp_today )
fig.savefig('figure/average_temperature_today.png')
plt.close(fig)
print "Figure for average_temperature_today complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, wet_bulb_tmp )
fig.savefig('figure/wet_bulb_tmp.png')
plt.close(fig)
print "Figure for wet_bulb_tmp complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, sat_vap_pres )
fig.savefig('figure/sat_vap_pres.png')
plt.close(fig)
print "Figure for sat_vap_pres complete !"


fig = plt.figure(figsize = (10,5))
plt.plot( time, vap_pres )
fig.savefig('figure/vap_pres.png')
plt.close(fig)
print "Figure for vap_pres complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, dry_air_pres )
fig.savefig('figure/dry_air_pres.png')
plt.close(fig)
print "Figure for dry_air_pres complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, dry_air_den )
fig.savefig('figure/dry_air_den.png')
plt.close(fig)
print "Figure for dry_air_den complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, abs_hum )
fig.savefig('figure/abs_hum.png')
plt.close(fig)
print "Figure for abs_hum complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, air_den_rto )
fig.savefig('figure/air_den_rto.png')
plt.close(fig)
print "Figure for air_den_rto complete !"

fig = plt.figure(figsize = (10,5))
plt.plot( time, adj_alt )
fig.savefig('figure/adj_alt.png')
plt.close(fig)
print "Figure for adj_alt complete !"


