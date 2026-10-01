#!/user/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/sensors_monitor.config"

SENSORS_LOGFILE="${SENSORS_LOGFILE}"

