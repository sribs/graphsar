#!/usr/bin/env python2
"""
Author        :Sriharsha B S
Email         :sribs@microsoft.com
Description   :Script to create a task graph
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
t_run_queue = []
t_total = []
t_blocked = []

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
        t_run_queue.append(float(row[1]))
        t_total.append(float(row[2]))
        t_blocked.append(float(row[6]))

# Plot lines
plt.plot(x,t_run_queue, label='Tasks in run queue', color='g', antialiased=True)
plt.plot(x,t_total, label='Total active tasks (processes + threads)', color='r', antialiased=True)
plt.plot(x,t_blocked, label='Blocked tasks', color='m', antialiased=True)

# Graph properties
plt.xlabel('Time',fontstyle='italic')
plt.ylabel('Tasks',fontstyle='italic')
plt.title('Tasks graph')
plt.grid(linewidth=0.4, antialiased=True)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fancybox=True, shadow=True)
plt.autoscale(True)

# Graph saved to PNG file
plt.savefig('../../graphs/tasks.png', bbox_inches='tight')
plt.show()
