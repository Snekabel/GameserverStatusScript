#!/usr/bin/env bash

if [ -f ${1} ]; then
  . ${1}
else
  echo "ERROR: $(pwd)/config.cfg not found"
  exit 1
fi

echo "Listening to  ${LISTEN_FILE}"
if [ "${2}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} ${1} listen
fi

while read line; do

#echo "${line}"
if $( echo "${line}" | grep -qP "${PLAYER_JOIN_FILTER}" ); then
    echo "${line}"
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_JOIN_FILTER}")
    echo "${PLAYER_NAME} Joined, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Joined"
elif $( echo "${line}" | grep -qP "${PLAYER_DISCONNECT_FILTER}" ); then
    echo "${line}"
    PLAYER_NAME=$(echo "${line}" | grep -oP "${PLAYER_DISCONNECT_FILTER}")
    echo "${PLAYER_NAME} Disconnected, Trigger curl"
    curl -q --data-urlencode "username=${PLAYER_NAME}" --data-urlencode "game=${GAME}" "${API_URL}Disconnected"
fi


done
