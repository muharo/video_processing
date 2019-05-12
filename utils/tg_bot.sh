#!/bin/bash

URL="https://api.telegram.org/bot${TG_TOKEN}/getUpdates"

response=$(curl -s -X POST $URL -d allowed_updates=["message"])
size=$(echo $response | jq '.result | length')

# if there are any updates, clear all
if [ $size -gt 0 ]; then
        offset=$(echo $response | jq '.result[-1].update_id')
        ((offset++))
        curl -s -X POST $URL -d allowed_updates=["message"] -d offset=$offset &>/dev/null
fi

while :
do
        result=$(curl -s -X POST $URL -d allowed_updates=["message"] -d offset=$offset | jq '.result[]')
        if [ -n "$result" ]; then
                offset=$(echo $result | jq '.update_id')
                ((offset++))
                message=$(echo $result | jq '.message.text' | tr -d '"' | tr '[:upper:]' '[:lower:]')
                case $message in
                        "/status")
                                kubectl get job video-worker &>/dev/null
                                if [ $? -ne 0 ]; then
                                        ./send_message.sh $TG_TOKEN $TG_CHAT_ID "There is no job running." &>/dev/null
                                else
                                        age=$(kubectl get job video-worker | tail --lines=1 | awk '{ print $4 }')
                                        line0="Age: ${age}"
                                        duration=$(kubectl get job video-worker | tail --lines=1 | awk '{ print $3 }')
                                        line1="Duration: ${duration}"
                                        line2=$(kubectl describe job video-worker | grep Parallelism | awk '$1=$1')
                                        line3=$(kubectl describe job video-worker | grep Completions| awk '$1=$1')
                                        line4=$(kubectl describe job video-worker | grep Statuses| awk '$1=$1')
                                        to_send=$(printf "$line0\n$line1\n$line2\n$line3\n$line4")
                                        ./send_message.sh $TG_TOKEN $TG_CHAT_ID "$to_send" &>/dev/null
                                fi
                                ;;
                        "/start")
                                ./send_message.sh $TG_TOKEN $TG_CHAT_ID "Hello master! How may I help?" &>/dev/null
                                ;;
                        *)
                                ./send_message.sh $TG_TOKEN $TG_CHAT_ID "Unknown command. Sorry." &>/dev/null
                                ;;
                esac
        fi
        sleep 1
done
