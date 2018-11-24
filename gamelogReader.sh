#!/usr/bin/env bash

LISTEN_FILE="./testdatastream"
API_URL="https://example.com/api/v1337/pokeme?apikey=ubastard"
TRIGGER_STRING=":10 "

if [ "${1}" !=  "listen" ]; then
   tail -f "${LISTEN_FILE}" | bash ${0} listen
fi

while read line; do

if $( grep -q "${TRIGGER_STRING}" ); then
    curl -q "${API_URL}"
fi

done
