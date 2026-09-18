#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/disk_monitor.conf"

DA_LOGFILE="${DM_LOGFILE}"
DA_FILESYSTEM="${1}"
DA_PERCENT="${2}"
DA_NOW="$(date --iso-8601=seconds)"
echo "${DA_NOW} ${DA_FILESYSTEM} ${DA_PERCENT}%" >> "${DA_LOGFILE}"
