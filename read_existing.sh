#!/bin/bash

cd $(dirname $0)


dump_sar_info(){
	# CPU
	sar -u -f $sa_file -s $start_time -e $end_time | grep -v -E "CPU|Average|RESTART|^$" > data/cpu.dat &
	# RAM
	sar -r -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/ram.dat &
	# Swap
	sar -S -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/swap.dat &
	# Load average and tasks
	sar -q -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/loadaverage.dat &
	# IO transfer
	sar -b -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/iotransfer.dat &
	# Process/context switches
	sar -w -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/proc.dat &
	# Network Interface
	sar -n DEV -f $sa_file -s $start_time -e $end_time | grep $network_interface | grep -v "Average" > data/netinterface.dat &
	# Sockets
	sar -n SOCK -f $sa_file -s $start_time -e $end_time | grep -v -E "[a-zA-Z]|^$" > data/sockets.dat &
}

check_sa_file(){
	if [ ! -f "$sa_file" ];then
		echo ""
		echo "ERROR: The file ${sa_file} does not exist"
		exit 1
	fi
}


howtouse(){
	cat <<-'EOF'

	This script can work only with parameters.
	If you use parameters, this is the correct format:
		-f [sa file]                  sar file to parse
		-s [hh:mm]                    start parse time in 24 hour format
		-e [hh:mm]                    end parse time in 24 hour format
    -i [network interface]        Network Interface eth0
	Examples:

		# Read Exisiting
		./read_existing.sh -f /var/log/sa/sa01 -s 09:00 -e 12:00 -i eth0

	EOF
}


if [ "$#" -eq 0 ];then
	echo -n "Please provide the required Arguments "
	
elif [ "$#" -ne 0 ];then
	while getopts ":f:s:e:i:lh" opt; do
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
			"i")
				network_interface="$OPTARG"
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
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

	# Call plotgraph.sh to generate the graphs
	./plotgraph.sh
fi
