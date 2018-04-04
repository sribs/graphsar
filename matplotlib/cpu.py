#!/usr/bin/env python2
"""
Author        :Sriharsha B S
Email         :sribs@microsoft.com
Description   :Script to create a graph about CPU usage : User, System, iowait
Dependencies  :Python 2.x, matplotlib
Usage         :python contextsw.py
"""
from datetime import datetime as dt
import random
import matplotlib.pyplot as plt
import csv
import matplotlib

plt.rcParams.update({'font.size': 8})
plt.rcParams['lines.linewidth'] = 1.5
time_format = matplotlib.dates.DateFormatter('%H:%M:%S')
plt.gca().xaxis.set_major_formatter(time_format)
plt.gcf().autofmt_xdate()

x=[]
system_cpu=[]
user_cpu=[]
idle_cpu=[]
io_wait=[]
# make up some data
with open('../../data/cpu.dat', 'r') as csvfile:
    data_source = csv.reader(csvfile, delimiter=' ', skipinitialspace=True)
    for row in data_source:
        # [0] column is a time column
        # Convert to datetime data type
        x.append(dt.strptime((row[0]),'%H:%M:%S'))
        # The remaining columns contain data
        user_cpu.append(float(row[2]))
        system_cpu.append(float(row[4]))
        idle_cpu.append(float(row[7]))
        io_wait.append(float(row[5]))
# Plot lines
plt.plot(x,user_cpu, label='User %', color='g', antialiased=True)
plt.plot(x,system_cpu, label='System %', color='r', antialiased=True)
plt.plot(x,idle_cpu, label='Idle %', color='b', antialiased=True)
plt.plot(x,io_wait, label='IO Wait %', color='c', antialiased=True)

# Graph properties
plt.xlabel('Time',fontstyle='italic')
plt.ylabel('CPU %',fontstyle='italic')
plt.title('CPU usage graph')
plt.grid(linewidth=0.4, antialiased=True)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fancybox=True, shadow=True)
plt.autoscale(True)

# Graph saved to PNG file
plt.savefig('../../graphs/cpu.png', bbox_inches='tight')
plt.show()
# beautify the x-labels
#plt.gcf().autofmt_xdate()


