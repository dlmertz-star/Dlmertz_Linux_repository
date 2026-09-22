#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/disk_monitor.conf"

DM_ALERT="${SCRIPT_DIR}/disk_alert.sh"

df --output='source','pcent' | grep '^/dev/' | while read -r DM_FILESYSTEM DM_PERCENT
do
	DM_PERCENTNUMBER= "${DM_PERCENT%/%}"
	if [ "${DM_PERCENTNUMBER}" -ge "${DM_THRESHOLD}" ]
	then
		"${DM_ALERT}" "${DM_FILESYSTEM}" "${DM_PERCENT}"
	fi
done

