#!/bin/bash +x

AXIS=$(echo $1 | tr '[:upper:]' '[:lower:]')
CURRENT_DATE=$(date +"%Y%m%d_%H%M")
INPUT="/tmp/resonances_${AXIS}_*.csv"
OUTPUT="${HOME}/klipper_config/input_shaper/${CURRENT_DATE}_shaper_calibrate_${AXIS}"

mkdir -p ~/klipper_config/input_shaper
~/klipper/scripts/calibrate_shaper.py $INPUT -o $OUTPUT
rm -f /tmp/resonances_$AXIS_*.csv
