#!/usr/bin/env bash

Threshold=1
alert="/home/desirae-mertz/Dlmertz_Linux_repository/disk_alert.sh"

df -h | grep -E '/dev/sd[a-z]|/dev/nvme[0-9]' | while read line
do
	filesystem=$(echo $line | awk '{print $1}')
	percent=$(echo $line | awk '{print $5}')
	percentNumber=$(echo $percent | tr -d '%')
	if [ "$percentNumber" -ge "$Threshold" ]
	then
		$alert $filesystem $percent
	fi
done

