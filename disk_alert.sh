#!/user/bin/env bash
Logfile="/home/desirae-mertz/disk-monitor.log"
filesystem=$1
percent=$2
now=$(date --iso-8601-seconds)
echo "$now $filesystem $percent" >> $Logfile
