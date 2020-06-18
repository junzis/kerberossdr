#!/bin/bash

BUFF_SIZE=256 # Must be a power of 2. Normal values are 128, 256. 512 is possible on a fast PC.


# set to /dev/null for no logging, set to some file for logfile. You can also set it to the same file.
RTLDAQLOG="tmp/rtl_daq.log"
SYNCLOG="tmp/sync.log"
GATELOG="tmp/gate.log"
PYTHONLOG="tmp/python.log"

# RTLDAQLOG="/dev/null"
# SYNCLOG="/dev/null"
# GATELOG="/dev/null"
# PYTHONLOG="/dev/null"

# If you want to kill all matching processes on startup without prompt. Otherwise, set it to anything else.
FORCE_KILL="yes"

NPROC=`expr $(nproc) - 1`

### End of Section ###

# Useful to set this on low power ARM devices
#sudo cpufreq-set -g performance

# Set for RPI3 with heatsink/fan
#sudo cpufreq-set -d 1.4GHz
# Set for Tinkerboard with heatsink/fan
#sudo cpufreq-set -d 1.8GHz

# Trap SIGINT (2) (ctrl-C) as well as SIGTERM (6), run cleanup if either is caught
trap cleanup 2 6

cleanup() {
	# Kill all processes that have been spawned by this program.
	# we know that these processes have "receiver", "gui" and "_webDisplay" in their names.
	exec 2> /dev/null           # Suppress "Terminated" message.
	sudo pkill -f "receiver"
	sudo pkill -f "gui"

	# also delete all pipes:
	rm -f tmp/gate_control_fifo
        rm -f tmp/sync_control_fifo
        rm -f tmp/rec_control_fifo
}


# Clear memory
sudo sh -c "echo 0 > /sys/module/usbcore/parameters/usbfs_memory_mb"
echo '3' | sudo dd of=/proc/sys/vm/drop_caches status=none

echo "Starting KerberosSDR"

# Check for old processes that could interfere, print warning:
for string in rtl sim sync gate hydra ; do
  pgrep -af $string
	if [[ $? -eq 0 ]] ; then
        if [[ "$FORCE_KILL" != "yes" ]]; then
            read -p "The processes listed above were found and could interfere with the program. Do you want to kill them now? [y|N]" -n1 -r
            echo # newline.
	    fi
		if [[ "$FORCE_KILL" == "yes" || "$REPLY" =~ ^[Yy]$ ]]
		then
			sudo pkill $string
		else
			echo "OK, not killing these processes. Hope you know what you're doing"
		fi
	fi
done

#sudo kill $(ps aux | grep 'rtl' | awk '{print $2}') 2>$OUTPUT_FD || true


sleep 1

# Create RAMDISK for jpg files
sudo mount -osize=30m tmpfs /ram -t tmpfs

# Remake Controller FIFOs. Deleting them should not be neccessary after
# a clean exit, but why not do it anyway...
rm -f tmp/gate_control_fifo
mkfifo tmp/gate_control_fifo

rm -f tmp/sync_control_fifo
mkfifo tmp/sync_control_fifo

rm -f tmp/rec_control_fifo
mkfifo tmp/rec_control_fifo

# Start programs at realtime priority levels
curr_user=$(whoami)

sudo chrt -r 50 taskset -c $NPROC ionice -c 1 -n 0 bin/rtl_daq $BUFF_SIZE 2>$RTLDAQLOG 1 | \
	sudo chrt -r 50 taskset -c $NPROC bin/sync $BUFF_SIZE 2>$SYNCLOG 1 | \
	sudo chrt -r 50 taskset -c $NPROC bin/gate $BUFF_SIZE 2>$GATELOG 1 | \
	sudo nice -n -20 sudo -u $curr_user python3 -O gui/main.py $BUFF_SIZE #&>$PYTHONLOG
