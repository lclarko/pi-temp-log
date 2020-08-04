#!/bin/bash
# Script: pi_temp_log.sh
# Use: Log the ARM CPU and GPU temperatures of your Raspberry Pi 4
# ASCII art adapted from user b3n on raspberrypi.org
# Tested on: LibreELEC 9.X.X
# Author: Lane Clark github.com/lclarko
# License: GPL-3.0
###########
echo "
   .~~.   .~~.        Raspberry Pi 4
  '. \ ' ' / .'         GPU + CPU
   .~ .~~~..~.      Temperature Monitor
  : .~.'~'.~. :
 ~ (   ) (   ) ~
( : '~'.~.'~' : )
 ~ .~ (   ) ~. ~
  (  : '~' :  )
   '~ .~~~. ~'
       '~'"

# Path to LOG_FILE and log file creation
LOG_FILE=./pi_temp.log
if [[ ! -f "./pi_temp.log" ]]
then touch pi_temp.log && echo "Created pi_temp.log"
fi

# Assign CPU temp to variable for future calculation
cpu=$( cat /sys/class/thermal/thermal_zone0/temp)
echo "$(date) @ $(hostname)" | tee -a ${LOG_FILE}
echo "-------------------------------------------"
echo "GPU     -  CPU   -  TIME"
while true; do

# Return GPU and CPU temp in celcius + 8601 timestamp
echo "$(/opt/vc/bin/vcgencmd measure_temp | cut -d = -f2)  -  $((cpu/1000))'C  -  $(date -I'seconds')" | tee -a ${LOG_FILE}

# Temperature measurement interval
sleep 3
done