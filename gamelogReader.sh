#!/usr/bin/env bash
LISTEN_DIR="/home/steam/7days/7DaysToDieServer_Data"
LISTEN_FILTER="output_log__*"
LISTEN_FILE=$(ls -r -1 ${LISTEN_DIR}/${LISTEN_FILTER} | head -n1)
PLAYER_JOIN_REGEX="(?<=Player ')(.*)(?=\' joined the game)"
PLAYER_DISCONNECT_REGEX="(?<=Player ')(.*)(?=\' left the game)"
GAME="7days to Die"

API_URL="http://example.com/player"

echo "Listening to  ${LISTEN_FILE}"
if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

#echo "${line}"
if $( echo "${line}" | grep -qP "${PLAYER_JOIN_REGEX}" ); then
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_JOIN_REGEX}")
    echo "${PLAYER_NAME} Joined, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Joined"
elif $( echo "${line}" | grep -qP "${PLAYER_DISCONNECT_REGEX}" ); then
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_DISCONNECT_REGEX}")
    echo "${PLAYER_NAME} Disconnected, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Disconnected"
fi


done
