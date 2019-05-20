#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage $0 TG_BOT_TOKEN TG_CHAT_ID MESSAGE"
    exit
fi

URL="https://api.telegram.org/bot${1}/sendMessage"

curl -s -X POST $URL -d chat_id=$2 -d text="$3"
