#!/bin/bash
# Script: pi_temp_log.sh
# Use: Logs the CPU and GPU temperatures and clock values of your Raspberry Pi 4
# ASCII art adapted from user b3n on raspberrypi.org
# Author: Lane Clark github.com/lclarko
# License: GPL-3.0
###########
echo "
   .~~.   .~~.        Raspberry Pi 4
  '. \ ' ' / .'         GPU + CPU
   .~ .~~~..~.         Temp + Clock
  : .~.'~'.~. :          Monitor
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

echo "$(date) @ $(hostname)" | tee -a ${LOG_FILE}
echo "-------------------------------------------"
echo "    CPU         -       GPU         -   TIME"

while true; do
# Assigning measurments to variables
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
gpu_temp=$(vcgencmd measure_temp | cut -d = -f2 | cut -d . -f 1)
arm_clock=$(vcgencmd measure_clock arm  | cut -d = -f2)
gpu_clock=$(vcgencmd measure_clock core  | cut -d = -f2)

# Return GPU and CPU temp in celcius + 8601 timestamp
echo "$((cpu_temp/1000))'C @ $((arm_clock/1000000))MHz   -   $((gpu_temp))'C @ $((gpu_clock/1000000))MHz   -   $(date -I'seconds')" | tee -a ${LOG_FILE}
# Measurement interval
sleep 3
done