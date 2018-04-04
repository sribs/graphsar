#!/bin/bash
#
# Script        :plotgraph.sh
# Author        :Sriharsha B S
# Email         :sribs@microsoft.com
# Description   :Script to generate graphs in the folder graphs/ of this repository
# Dependencies  :sar,gnuplot
# Usage         :1)Give executable permissions to script -> chmod +x plotter.sh
#                2)Execute script -> ./plotgraph.sh
# License       :Apache License Vers 2.0
#

# Read graphsar.properties file
. graphsar.properties

cd plotters/matplotlib
python loadaverage.py
python tasks.py
python cpu.py
python ram.py
python swap.py
python iotransfer.py
python proc.py
python contextsw.py
python netinterface.py
python sockets.py
