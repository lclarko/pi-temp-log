# pi-temp-log

## Purpose:
Logging the CPU and GPU temperatures and clock values of your Raspberry Pi 4

The script will output the GPU and CPU temperatures and clock values, timestamped in ISO 8601 and write that output to a log file. Future logging sessions will be appended to the log file.

## Requirements:
- A Raspberry Pi 4 (Should work on 3 also, perhaps with slight modification)
- Shell access with root privileges

## Usage:

**./pi_temp_log.sh**

> Note: To run the script, you must first grant it execute privileges. Run this command in the same directory as the script:

**chmod +x pi_temp_log.sh**

## Sample Output:

```
Fri Aug  7 02:34:11 UTC 2020 @ LibreELEC
-------------------------------------------
CPU			        GPU			        TIME
32'C	750MHz		32'C	250MHz		2020-08-07T02:34:11+0000
30'C	750MHz		30'C	250MHz		2020-08-07T02:34:14+0000
30'C	750MHz		30'C	250MHz		2020-08-07T02:34:17+0000
30'C	750MHz		30'C	250MHz		2020-08-07T02:34:20+0000
29'C	750MHz		29'C	250MHz		2020-08-07T02:34:23+0000
```

## The Code

```bash
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

echo -e "$(date) @ $(hostname)" | tee -a ${LOG_FILE}
echo -e "-------------------------------------------"
echo -e "CPU\t\t\tGPU\t\t\tTIME"

while true; do
# Assigning measurments to variables
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
gpu_temp=$(vcgencmd measure_temp | cut -d = -f2 | cut -d . -f 1)
arm_clock=$(vcgencmd measure_clock arm  | cut -d = -f2)
gpu_clock=$(vcgencmd measure_clock core  | cut -d = -f2)

# Return all the values + 8601 timestamp
echo -e "$((cpu_temp/1000))'C\t$((arm_clock/1000000))MHz\t\t$((gpu_temp))'C\t$((gpu_clock/1000000))MHz\t\t$(date -I'seconds')" | tee -a ${LOG_FILE}
# Measurement interval
sleep 3
done
```

## Future Enhancements 
- Implement column