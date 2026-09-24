#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/disk_monitor.conf"

DM_ALERT="${SCRIPT_DIR}/disk_alert.sh"

DM_DF_OUTPUT="$(df -P)"

DM_COLS="$(awk '
	NR == 1 {
		for (i = 1; i <= NF; i++) {
			field = tolower($i)
			if (fs_col == 0 && field ~ /filesystem/) fs_col = i
			if (field ~/capacity/) {
				candidates[++n] = i
				valid[i] = 1
			}
		}
		if (fs_col == 0) fs_col = 1
		next
	}
	$fs_col ~ /^\/dev\// {
		for (i=1; i<=n; i++) {
			c = candidates[i]
			if (valid[c] == 0) continue
			val = $c
			if (val !~ /^[0-9]{1,3}%$/) { valid[c] = 0; continue }
			num = val + 0
			if (num <= 0 || num > 100) valid[c] = 0
		}
	}
	END {
		pct_col = 0
		for (i = 1; i <= n; i++) {
			c = candidates[i]
			if (valid[c] == 1) { pct_col = c; break }
		}
		print fs_col, pct_col
	}
' <<< "${DM_DF_OUTPUT}")"

DM_FS_COL="${DM_COLS%% *}"
DM_PERCENT_COL="${DM_COLS##* }"

if [ -z "${DM_PERCENT_COL}" ] || [ "${DM_PERCENT_COL}" -eq 0 ]
	then
		echo "${SCRIPT_NAME}: could not find a usage-percentage colum in 'df' output" >&2
	exit 1
fi

awk -v fscol="${DM_FS_COL}" -v col="${DM_PERCENT_COL}" '
	$fscol ~ /^\/dev\// {
		pct = $col
		gsub (/%/, "", pct)
		print $fscol, pct
	}
' <<< "${DM_DF_OUTPUT}" | while read -r DM_FILESYSTEM DM_PERCENTNUMBER
do
	if [ "${DM_PERCENTNUMBER}" -ge "${DM_THRESHOLD}" ]
	then
		"${DM_ALERT}" "${DM_FILESYSTEM}" "${DM_PERCENTNUMBER}%"
	fi
done

