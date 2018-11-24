#!/usr/bin/env bash

LISTEN_FILE=$(ls -r -1 $(dirname $(readlink -f ${0})) | head -n1)
API_URL="https://example.com/api/v1337/pokeme?apikey=ubastard"
TRIGGER_STRING="PlayerLogin:"

if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

if $( echo "${line}" | grep -q "${TRIGGER_STRING}" ); then
    PLAYER_NAME=$(echo "${line}" | cut -d":" -f4- | rev | cut -d"/" -f2- | rev | cut -c2-)
    echo "${PLAYER_NAME} Joined, Trigger curl"
#   curl -q --data-urlencode "username=${PLAYER_NAME}" "${API_URL}"
fi

done
