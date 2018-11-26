#!/usr/bin/env bash
LISTEN_DIR="/home/steam/7days/7DaysToDieServer_Data"
LISTEN_FILTER="output_log__*"
LISTEN_FILE=$(ls -r -1 ${LISTEN_DIR}/${LISTEN_FILTER} | head -n1)
PLAYER_JOIN_FILTER='grep -oP "(?<=Player ')(.*)(?=\' joined the game)"'
PLAYER_DICONNECT_FILTER='grep -oP "(?<=Player ')(.*)(?=\' left the game)"'

API_URL="http://example.com/player"

if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

#echo "${line}"
if $( echo "${line}" | grep -qP "${PLAYER_JOIN_FILTER}" ); then
    PLAYER_NAME=$(echo "${line}" | ${PLAYER_JOIN_FILTER})
    echo "${PLAYER_NAME} Joined, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" "${API_URL}Joined"
elif $( echo "${line}" | ${PLAYER_DISCONNECT_FILTER} ); then
    PLAYER_NAME=$(echo "${line}" | ${PLAYER_DISCONNECT_FILTER})
    echo "${PLAYER_NAME} Disconnected, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" "${API_URL}Disconnected"
fi


done
