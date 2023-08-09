#!/bin/sh

## If internet is reachable, script exits with code 0
## If internet is not reachable, script exits with code 1

DEFAULT_TIMEOUT_S=10
DEFAULT_MAX_ATTEMPTS=1
DEFAULT_SLEEP_S=0
DETECTION_URL="http://detectportal.firefox.com/success.txt"

TIMEOUT_S="${1:-$DEFAULT_TIMEOUT_S}"
MAX_ATTEMPTS="${2:-$DEFAULT_MAX_ATTEMPTS}"
SLEEP_S="${3:-$DEFAULT_SLEEP_S}"

attempts=0

while [ $attempts -lt $MAX_ATTEMPTS ]; do
  detection_out=$(uclient-fetch -q --timeout="$TIMEOUT_S" $DETECTION_URL -O - 2> /dev/null)

  if [ "$detection_out" = "success" ]; then
    exit 0
  fi

  attempts=$((attempts+1))
  sleep $SLEEP_S
done

exit 1
