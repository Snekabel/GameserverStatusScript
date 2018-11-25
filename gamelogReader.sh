#!/usr/bin/env bash

LISTEN_DIR="7DaysToDieServer_Data"
LISTEN_FILTER="output_log__*"
LISTEN_FILE=$(ls -r -1 "${LISTEN_DIR}/${LISTEN_FILTER}" | head -n1)
REGEX="(?<=PlayerLogin: )(.*)(?=\/)";

API_URL="http://example.com/api/"

if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

if $( echo "${line}" | grep -q "${TRIGGER_STRING}" ); then
    PLAYER_NAME=$(echo "${line}" | grep -oP '(?<=PlayerLogin: )(.*)(?=\/)')
    echo "${PLAYER_NAME} Joined, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" "${API_URL}"
fi

done
