#!/usr/bin/env bash

if [ -f ./config.cfg ]; then
  . ./config.cfg
else
  echo "ERROR: $(pwd)/config.cfg not found"
  exit 1
fi

echo "Listening to  ${LISTEN_FILE}"
if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

#echo "${line}"
if $( echo "${line}" | grep -qP "${PLAYER_JOIN_FILTER}" ); then
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_JOIN_FILTER}")
    echo "${PLAYER_NAME} Joined, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Joined"
elif $( echo "${line}" | grep -qP "${PLAYER_DISCONNECT_FILTER}" ); then
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_DISCONNECT_FILTER}")
    echo "${PLAYER_NAME} Disconnected, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Disconnected"
fi


done
