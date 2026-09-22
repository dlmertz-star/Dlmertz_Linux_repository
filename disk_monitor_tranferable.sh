#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/disk_monitor.conf"

DM_ALERT="${SCRIPT_DIR}/disk_alert.sh"

DM_DF_OUTPUT="$(df -P)"

DM_PERCENT_COL="$(awk '
	NR == 1 {
		for (i = 1; i <= NF; i++) {
			field = tolower($i)
			if (field ~/capacity/) {
				print i
				exit
			}
		}
	}
' <<< "${DM_DF_OUTPUT}")"

if [ -z "${DM_PERCENT_COL}" ]
	then
		echo "${SCRIPT_NAME}: could not find a usage-percentage colum in 'df' output" >&2
	exit 1
fi

awk -v col="${DM_PERCENT_COL}" '
	$1 ~ /^\/dev\// {
		pct = $col
		gsub (/%/, "", pct)
		print $1, pct
	}
' <<< "${DM_DF_OUTPUT}" | while read -r DM_FILESYSTEM DM_PERCENTNUMBER
do
	if [ "${DM_PERCENTNUMBER}" -ge "${DM_THRESHOLD}" ]
	then
		"${DM_ALERT}" "${DM_FILESYSTEM}" "${DM_PERCENTNUMBER}%"
	fi
done

