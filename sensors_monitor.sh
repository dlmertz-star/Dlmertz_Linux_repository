#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/sensors_monitor.conf"

SENSORS_TEMP_ALERT="${SCRIPT_DIR}/sensors_alert.sh"

if ! command -v sensors >/dev/null 2>&1
then
	echo "${SCRIPT_NAME}: sensors command not found" >&2
	exit 1
fi

if [[ ! "${MAX_TEMP}" =~ ^[0-9]+([.][0-9]+)?$ ]]
then
	echo "${SCRIPT_NAME}: MAX_TEMP must be a non-negative number" >&2
	exit 1
fi

sensors | awk -v threshold="${MAX_TEMP}" '
	/°C/ {
		sensor = $0
		sub(/:.*/, "", sensor)
		if (match($0, /[+-]?[0-9]+([.][0-9]+)?°C/)) {
			temperature = substr($0, RSTART, RLENGTH)
			number = temperature
			sub(/°C$/, "", number)
			sub(/^\+/, "", number)
			if (number > threshold)
				print sensor "\t" temperature
		}
	}
' | while IFS=$'\t' read -r SENSORS_NAME SENSORS_TEMPERATURE
do
	bash "${SENSORS_TEMP_ALERT}" "${SENSORS_NAME}" "${SENSORS_TEMPERATURE}"
done

