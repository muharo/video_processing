#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Provide number of expected completions."
    exit
fi

while :
do
    date=$(date)
    count=$(kubectl get pods | grep Completed | wc -l)
    if [ $count -eq $1 ]; then
        ./send_message.sh $TG_TOKEN $TG_CHAT_ID "Test completed." &>/dev/null
        exit
    fi
    sleep 1
done
