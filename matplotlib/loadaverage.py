#!/usr/bin/env python2
"""
Author        :Sriharsha B S
Email         :sribs@microsoft.com
Description   :Script to create load average graph
Dependencies  :Python 2.x, matplotlib
Usage         :python contextsw.py
"""
import matplotlib
import matplotlib.pyplot as plt 
import csv
from datetime import datetime
import matplotlib.dates

# ======================
# VARIABLES
# ======================

# Aesthetic parameters
plt.rcParams.update({'font.size': 8})
plt.rcParams['lines.linewidth'] = 1.5
time_format = matplotlib.dates.DateFormatter('%H:%M:%S')
plt.gca().xaxis.set_major_formatter(time_format)
plt.gcf().autofmt_xdate()

# Time (column 0)
x = []
# Data arrays
m1 = []
m5 = []
m15 = []

# ======================
# FUNCTIONS
# ======================

with open('../../data/loadaverage.dat', 'r') as csvfile:
    data_source = csv.reader(csvfile, delimiter=' ', skipinitialspace=True)
    for row in data_source:
        # [0] column is a time column
        # Convert to datetime data type
        a = datetime.strptime((row[0]),'%H:%M:%S')
        x.append((a))
        # The remaining columns contain data
        m1.append(float(row[3]))
        m5.append(float(row[4]))
        m15.append(float(row[5]))

# Plot lines
plt.plot(x,m1, label='1 min', color='g', antialiased=True)
plt.plot(x,m5, label='5 min', color='r', antialiased=True)
plt.plot(x,m15, label='15 min', color='b', antialiased=True)

# Graph properties
plt.xlabel('Time',fontstyle='italic')
plt.ylabel('Load average',fontstyle='italic')
plt.title('Load average graph')
plt.grid(linewidth=0.4, antialiased=True)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fancybox=True, shadow=True)
plt.autoscale(True)

# Graph saved to PNG file
plt.savefig('../../graphs/loadaverage.png', bbox_inches='tight')
plt.show()

# ======================
# MAIN
# ======================
