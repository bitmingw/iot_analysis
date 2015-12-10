# ECE 6607 Project
# Data Profiler
# Q.Ju
# Oct.22, 2015
# Test on ecelinsrvx.ece.gatech.edu

import os
import csv
import sys
import time
import numpy as np
#import openpyxl as px
import matplotlib as mpl
mpl.use( 'Agg' )
import matplotlib.pyplot as plt
import os




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
time = []

for num_files in range(0,3):

	f = open( sys.argv[1+num_files], 'rb' )

	num_headers = 4
	for x in range(0,num_headers):
		f.next() # skip first header line
	i = 0
	col_off = 1;

	time.append([])
	t_list.append([])
	temp_list.append([])
	wind_chi.append([])
	heat_idx.append([])
	dew_point.append([])
	deg_day.append([])
	dens_alt.append([])
	avg_temp_today.append([])
	wet_bulb_glob_temp.append([])
	sat_vap_pres.append([])
	vap_pres.append([])
	dry_air_pres.append([])
	dry_air_den.append([])
	abs_hum.append([])
	air_den_rto.append([])
	adj_alt.append([])
	sae_cor_fac.append([])
	wet_air_den.append([])
	wet_bulb_tmp.append([])
	rel_hum.append([])
	avg_wind_spd.append([])
	wind_spd_mx.append([])
	wind_spd_mn.append([])
	raw_wind_dir.append([])
	raw_wind_dir_av.append([])
	raw_wind_dir_mx.append([])
	raw_wind_dir_mn.append([])
	sec3_roll_avg_wind_spd.append([])
	sec3_roll_avg_wind_dir.append([])
	min2_roll_avg_wind_spd.append([])	
	min2_roll_avg_wind_dir.append([])
	min10_roll_avg_wind_spd.append([])
	min10_roll_avg_wind_dir.append([])
	min60_wind_gust_dir.append([])
	min60_wind_gust_spd.append([])
	min10_wind_gust_dir.append([])
	min10_wind_gust_spd.append([])
	rain_tdy.append([])
	rain_this_wk.append([])
	rain_this_mth.append([])
	rain_this_yr.append([])
	rain_rate.append([])
	rain_last_hr.append([])
	prec_type.append([])
	raw_barom_pres.append([])
	adj_barom_pres.append([])



	print "Reading src data file: %s "  % sys.argv[1+num_files]
	filename, file_ext = os.path.splitext(sys.argv[1+num_files])





	#header
	header_list = []


	#time list in hour
	










	try:
    		reader = csv.reader(f)   
    		for row in reader:
			t_list[num_files].append( row[0+col_off] )
			temp_list[num_files].append( float(row[1+col_off]) )
			wind_chi[num_files].append( float(row[2+col_off]) )
			heat_idx[num_files].append( int(row[3+col_off]) )
			dew_point[num_files].append( float(row[4+col_off]) )
			deg_day[num_files].append( float(row[5+col_off]) )
			#print(row[6+col_off])
			dens_alt[num_files].append( float(row[6+col_off]) )
	
			avg_temp_today[num_files].append( float(row[7+col_off]) )
			wet_bulb_glob_temp[num_files].append( float(row[8+col_off]) )
			sat_vap_pres[num_files].append( float(row[9+col_off]) )
			vap_pres[num_files].append( float(row[10+col_off]) )
			dry_air_pres[num_files].append( float(row[11+col_off]) )
			dry_air_den[num_files].append( float(row[12+col_off]) )
			abs_hum[num_files].append( float(row[13+col_off]) )
			air_den_rto[num_files].append( float(row[14+col_off]) )
			adj_alt[num_files].append( float(row[15+col_off]) )
			sae_cor_fac[num_files].append( float(row[16+col_off]) )
			wet_air_den[num_files].append( float(row[17+col_off]) )
			wet_bulb_tmp[num_files].append( float(row[18+col_off]) )
			rel_hum[num_files].append( float(row[19+col_off]) )
			avg_wind_spd[num_files].append( float(row[20+col_off]) )
			wind_spd_mx[num_files].append( float(row[21+col_off]) )
			wind_spd_mn[num_files].append( float(row[22+col_off]) )
			raw_wind_dir[num_files].append( float(row[23+col_off]) )
			raw_wind_dir_av[num_files].append( float(row[24+col_off]) )
			raw_wind_dir_mx[num_files].append( float(row[25+col_off]) )
			raw_wind_dir_mn[num_files].append( float(row[26+col_off]) )
			sec3_roll_avg_wind_spd[num_files].append( float(row[27+col_off]) )
			sec3_roll_avg_wind_dir[num_files].append( float(row[28+col_off]) )
			min2_roll_avg_wind_spd[num_files].append( float(row[29+col_off]) )
			min2_roll_avg_wind_dir[num_files].append( float(row[30+col_off]) )
			min10_roll_avg_wind_spd[num_files].append( float(row[31+col_off]) )
			min10_roll_avg_wind_dir[num_files].append( float(row[32+col_off]) )
			min60_wind_gust_dir[num_files].append( int(row[33+col_off]) )
			min60_wind_gust_spd[num_files].append( row[34+col_off] )
			min10_wind_gust_dir[num_files].append( int(row[35+col_off]) )
			min10_wind_gust_spd[num_files].append( row[36+col_off] )
			rain_tdy[num_files].append( float(row[37+col_off]) )
			rain_this_wk[num_files].append( float(row[38+col_off]) )
			rain_this_mth[num_files].append( float(row[39+col_off]) )
			rain_this_yr[num_files].append( float(row[40+col_off]) )
			rain_rate[num_files].append( float(row[41+col_off]) )
			rain_last_hr[num_files].append( float(row[42+col_off]) )
			prec_type[num_files].append( float(row[43+col_off]) )
			raw_barom_pres[num_files].append( float(row[44+col_off]) )
			adj_barom_pres[num_files].append( float(row[45+col_off]) )
	
			time[num_files].append(float(i)/float(60))
			i = i + 1





	#if i < 10:	
	#    print raw_wind_dir[i]

   			
	finally:
    		f.close()
		


	str_path = 'figure_csv/' + sys.argv[num_files+1]

	print "Total Lines(header not included):  %d " % i

	if not os.path.exists(str_path):
		os.makedirs(str_path)

'''
 
	fig = plt.figure(figsize = (10,5))
	plt.plot( time[num_files], temp_list[num_files] )
	fig.savefig(str_path+'/temp_list.png')
	plt.close(fig)
	print "Figure for Temperature complete !"


	fig = plt.figure(figsize = (10,5))
	plt.plot( time[num_files], avg_wind_spd[num_files] )
	fig.savefig(str_path+'/avg_wind_spd.png')
	plt.close(fig)
	print "Figure for Average Wind Speed complete !"

	fig = plt.figure(figsize = (10,5))
	plt.plot( time[num_files], vap_pres[num_files] )
	fig.savefig(str_path+'/vap_pre.png')
	plt.close(fig)
	print "Figure for Vapor Pressure complete !"


	fig = plt.figure(figsize = (10,5))
	plt.plot( time[num_files], dry_air_pres[num_files] )
	fig.savefig(str_path+'/dry_air_pres.png')
	plt.close(fig)
	print "Figure for Dry Air Pressure complete !"


	fig = plt.figure(figsize = (10,5))
	plt.plot( time[num_files], wet_air_den[num_files] )
	fig.savefig(str_path+'/wet_air_den.png')
	plt.close(fig)
	print "Figure for Wet AIr Density complete !"


'''




fig = plt.figure(figsize = (30,15))
plt.plot( time[0], temp_list[0], 'r', label = sys.argv[1] )
plt.plot( time[1], temp_list[1], 'g', label = sys.argv[2] )
plt.plot( time[2], temp_list[2], 'b', label = sys.argv[3] )
plt.legend( loc = 'upper right' )

fig.savefig('figure_csv/temperature.png')
plt.close(fig)


fig = plt.figure(figsize = (30,15))
plt.plot( time[0], avg_wind_spd[0], 'r', label = sys.argv[1] )
plt.plot( time[1], avg_wind_spd[1], 'g', label = sys.argv[2] )
plt.plot( time[2], avg_wind_spd[2], 'b', label = sys.argv[3] )
plt.legend( loc = 'upper right' )

fig.savefig('figure_csv/avg_wind_spd.png')
plt.close(fig)


fig = plt.figure(figsize = (30,15))
plt.plot( time[0], vap_pres[0], 'r', label = sys.argv[1] )
plt.plot( time[1], vap_pres[1], 'g', label = sys.argv[2] )
plt.plot( time[2], vap_pres[2], 'b', label = sys.argv[3] )
plt.legend( loc = 'upper right' )

fig.savefig('figure_csv/vap_pres.png')
plt.close(fig)


fig = plt.figure(figsize = (30,15))
plt.plot( time[0], dry_air_pres[0], 'r', label = sys.argv[1] )
plt.plot( time[1], dry_air_pres[1], 'g', label = sys.argv[2] )
plt.plot( time[2], dry_air_pres[2], 'b', label = sys.argv[3] )
plt.legend( loc = 'upper right' )

fig.savefig('figure_csv/dry_air_pres.png')
plt.close(fig)


fig = plt.figure(figsize = (30,15))
plt.plot( time[0], wet_air_den[0], 'r', label = sys.argv[1] )
plt.plot( time[1], wet_air_den[1], 'g', label = sys.argv[2] )
plt.plot( time[2], wet_air_den[2], 'b', label = sys.argv[3] )
plt.legend( loc = 'upper right' )

fig.savefig('figure_csv/wet_air_den.png')
plt.close(fig)

























