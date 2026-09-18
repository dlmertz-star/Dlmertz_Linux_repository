#!/usr/bin/env bash

SCRIPT_DIR="${cd "(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCIPT_NAME="$(basname "${BASH_SOURCE[0]}")"

source "${(SCRIPT_DIR}/disk_monitor.conf"

DM_ALERT="${HOME}/disk_alert.sh"

df -h | grep -E '/dev/sd[a-z]|/dev/nvme[0-9]' | while read line
do
	DM_FILESYSTEM="$(echo "${line}" | awk '{print "${1}"}')"
	DM_PERCENT="$(echo "${line}" | awk '{print "${5}"}')"
	DM_PERCENTNUMBER=$(echo "${DM_PERCENT}" | tr -d '%')
	if [ "${DM_PERCENTNUMBER}" -ge "${DM_THRESHOLD}" ]
	then
		"${DM_ALERt}" "${DM_FILESYSTEM}" "${DM_PERCENT}"
	fi
done

