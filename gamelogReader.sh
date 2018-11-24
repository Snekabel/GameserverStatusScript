#!/usr/bin/env bash

LISTEN_FILE="./testdatastream"
API_URL="https://example.com/api/v1337/pokeme?apikey=ubastard&username="
TRIGGER_STRING="PlayerLogin:"

if [ "${1}" !=  "listen" ]; then
   tail -n0 -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

if $( echo "${line}" | grep -q "${TRIGGER_STRING}" ); then
    PLAYER_NAME=$(echo "${line}" | cut -d":" -f4- | rev | cut -d"/" -f2- | rev | cut -c2-)
    echo "${PLAYER_NAME}"
#    curl -q "${API_URL}${PLAYER_NAME}"
fi

done
