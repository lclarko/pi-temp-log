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
Sat Aug  1 20:20:28 UTC 2020 @ LibreELEC
-------------------------------------------
    CPU         -       GPU         -   TIME
32'C @ 750MHz   -   32'C @ 250MHz   -   2020-08-06T04:21:47+0000
32'C @ 750MHz   -   32'C @ 333MHz   -   2020-08-06T04:21:50+0000
32'C @ 750MHz   -   32'C @ 250MHz   -   2020-08-06T04:21:54+0000
31'C @ 750MHz   -   31'C @ 250MHz   -   2020-08-06T04:21:57+0000
32'C @ 1000MHz   -   32'C @ 333MHz   -   2020-08-06T04:22:00+0000
```

## The Code

```bash
#!/bin/sh
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

# Return all the values + 8601 timestamp
echo "$((cpu_temp/1000))'C @ $((arm_clock/1000000))MHz   -   $((gpu_temp))'C @ $((gpu_clock/1000000))MHz   -   $(date -I'seconds')" | tee -a ${LOG_FILE}
# Measurement interval
sleep 3
done
```

## Future Enhancements 
- Implement column