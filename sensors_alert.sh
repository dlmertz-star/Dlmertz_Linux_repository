#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/sensors_monitor.conf"

SENSORS_LOGFILE="${SENSORS_LOGFILE}"
SENSORS_NAME="${1}"
SENSORS_TEMPERATURE="${2}"
SENSORS_NOW="$(date --iso-8601=seconds)"
echo "${SENSORS_NOW} ${SENSORS_NAME} ${SENSORS_TEMPERATURE}" >> "${SENSORS_LOGFILE}"
