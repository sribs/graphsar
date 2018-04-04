#!/bin/bash

# Initialize in sarviewer folder
cd $(dirname $0)

# ======================
# VARIABLES
# ======================

# Read sarviewer.properties file
. graphsar.properties

# ======================
# FUNCTIONS
# ======================

dump_sar_info(){
	# CPU
	sar -u -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "CPU|Average|RESTART|^$" > data/cpu.dat &
	# RAM
	sar -r -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/ram.dat &
	# Swap
	sar -S -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/swap.dat &
	# Load average and tasks
	sar -q -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/loadaverage.dat &
	# IO transfer
	sar -b -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/iotransfer.dat &
	# Process/context switches
	sar -w -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/proc.dat &
	# Network Interface
	sar -n DEV -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep $network_interface | grep -v "Average" > data/netinterface.dat &
	# Sockets
	sar -n SOCK -f $sysstat_logdir/$sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/sockets.dat &
}

check_sa_file(){
	if [ ! -f "$sysstat_logdir/$sa_file" ];then
		echo ""
		echo "ERROR: The file ${sysstat_logdir}/${sa_file} does not exist"
		echo "Please select a valid \"sa\" file from the list"
		exit 1
	fi
}

list_sa_files(){
	echo "List of sa* files available at this moment to retrieve data from:"
	echo ""
	echo "-------------------------------------------"
	for file in $(ls ${sysstat_logdir} | grep -v sar);do
		echo "File ${file} with data from $(sar -r -f ${sysstat_logdir}/${file} | head -1 )";
	done
	echo "-------------------------------------------"
	echo ""
	echo "Note that the number that follows the \"sa\" file specifies the day of the data collected by sar daemon"	
}

howtouse(){
	cat <<-'EOF'

	This script can work with or without parameters.
	Without parameters, just execute it --> ./read_existing.sh
	If you use parameters, this is the correct format:
		-f [sa file]                  sar file to parse
		-s [hh:mm]                    start parse time in 24 hour format
		-e [hh:mm]                    end parse time in 24 hour format
		-m [mail]                     mail address to send the graphs to
		-l                            list available sa files
		-h                            help
	
	Examples:

		# Send by email day 04 statistics
		./read_existing.sh -f sa04 -m example@example.com

		# Send by email day 04 statistics between 09:00 and 12:00
		./read_existing.sh -f sa04 -s 09:00 -e 12:00 -m example@example.com

		# Send by email day 05 statistics just since 10:00 
		./read_existing.sh -f sa05 -s 10:00 -m example@example.com

		# Just parse day 05 statistics
		./read_existing.sh -f sa05

		# Send yesterday's statistics statistics by email:
		./read_existing.sh -f sa$(date +%d -d yesterday) -m example@example.com

		# Send today's statistics statistics by email:
		./read_existing.sh -f sa$(date +%d) -m example@example.com

	EOF
}

# ======================
# MAIN
# ======================

if [ "$#" -eq 0 ];then
	list_sa_files
	echo -n "Please select a sa* file from the listed above: "
	read sa_file

	# Check if the selected sa_file exists
	check_sa_file

	# Dump data contained in selected sar file
	dump_sar_info

	# Call plotter.sh to generate the graphs
	./plotter.sh
	
elif [ "$#" -ne 0 ];then
	while getopts ":f:s:e:m:lh" opt; do
		case $opt in
			"f")
				sa_file="$OPTARG"
				;;
			"s")
				start_time="$OPTARG"
				;;
			"e")
				end_time="$OPTARG"
				;;
			"l")
				list_sa_files
				exit 0
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				howtouse
				exit 1
				;;
			:)
				echo "Option -$OPTARG requires an argument." >&2
				howtouse
				exit 1
				;;
			"h" | *)
				howtouse
				exit 1
				;;
		esac
	done
	# Check if the selected sa_file exists
	check_sa_file

	# Dump data contained in selected sar file
	dump_sar_info

	# Call plotter.sh to generate the graphs
	./plotgraph.sh
fi
