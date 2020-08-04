# pi-temp-log

## Purpose:
Log the ARM CPU and GPU temperatures of your Raspberry Pi 4.

The script will output the GPU and CPU temperatures timestamped in ISO 8601 and write that output to a log file. Future logging sessions will be appended to the log file.

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
GPU     -  CPU   -  TIME
33.0'C  -  33'C  -  2020-08-01T20:20:28+0000
32.0'C  -  33'C  -  2020-08-01T20:20:31+0000
33.0'C  -  33'C  -  2020-08-01T20:20:34+0000
33.0'C  -  34'C  -  2020-08-01T20:20:37+0000
32.0'C  -  34'C  -  2020-08-01T20:20:40+0000
```

## The Code

```bash
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

echo "$(date) @ $(hostname)" | tee -a ${LOG_FILE}
echo "-------------------------------------------"
echo "GPU     -  CPU   -  TIME"

while true; do
# Assign CPU temp to variable for future calculation
cpu=$( cat /sys/class/thermal/thermal_zone0/temp)

# Return GPU and CPU temp in celcius + 8601 timestamp
echo "$(/opt/vc/bin/vcgencmd measure_temp | cut -d = -f2)  -  $((cpu/1000))'C  -  $(date -I'seconds')" | tee -a ${LOG_FILE}

# Temperature measurement interval
sleep 3
done
```

## Future Enhancements 
- Change GPU to INT value
- Add clock values to output
