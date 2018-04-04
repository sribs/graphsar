# graphsar
SAR Graph plotter Tool.
The following data are plotted using the SAR logs
* CPU usage
* Load average
* RAM usage
* I/O transfer
* Processes created per second
* Context switches
* Tasks (run queue, active, blocked)
* Network interface statistics (eth0 by default)
* TCP/UDP sockets

Inspired by the following Link : https://github.com/juliojsb/sarviewer

## Requirements
* Existing SAR Logs
* Windows Subsystem for Linux (Ubuntu). Location : Microsoft Store
* Xming Server for windows. Download Link : https://sourceforge.net/projects/xming/
* Update the existing repository in Windows Subsystem for Linux (Ubuntu)
```bash
apt-get update --fix-missing
```
* Install the following packages using the following command
```bash
apt-get install python sysstat python-dev python-tk python-matplotlib
```
* Git for source control.
* Download the graphsar package using git
 ```bash
 git clone https://github.com/sribs/graphsar
 ```
 
 ## Usage
 * Launch the Xming application on Windows
 * set the display parameter in the Windows Subsystem Ubuntu
 ```bash
 export DISPLAY=:0
 ```
 * Go to the directory where it is cloned from git.
 * open the File ``` graphsar.properties ```.
 * set the default readings : 
 ``` sh
 # Log dir where sa* files are stored
# By default folder /var/log/sysstat
sysstat_logdir="/var/log/sysstat"

# Variable network_interface specifies the interface for netinterface statistics graph
# By default, eth0
network_interface="eth0"

# Default start time to parse statistics
start_time="00:00:00"

# Default end time to parse statistics
end_time="23:59:59"
 ```
* Run the file read_existing.sh using the command
```bash
./read_existing.sh
```
* If this command is already performed, no need of running the above command. Instead run this command
```bash
./plotgraph.sh
```
* This will open an interactive window where we can zoom the graph and derive accurate conclusions.

* The above operation will get the details from the existing SAR file location in ```graphsar.properties``` file
* All the images are stored in graphs folder. This can be shared over an email.

## Output
### CPU Usage

![Alt text](https://raw.githubusercontent.com/sribs/graphsar/master/graphs/cpu.png "CPU Usage")

## Next Release
* Planning to integrate HTML support with this.
