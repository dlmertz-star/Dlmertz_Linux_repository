#!/user/bin/env bash

Threshold=90
alert="/home/desirae-mertz/Dlmertz_Linux_repository/disk_alert.sh"

df -h | grep -E '/dev/sd?|/dev/nvme?' | while read line
do
	filesystem=$(echo $line | awk '{print $1}')
	percent=$(echo $line | awk '{print $5}')
	percentNumber=$(echo $percent | tr -d '%')
	if [ $percentNumber -ge $THRESHOLD]
	then
		$alert $filesystem $percent
	fi
done

