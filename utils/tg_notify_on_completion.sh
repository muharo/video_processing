#!/bin/bash

while :
do
    date=$(date)
    target=$(kubectl describe job video-worker | grep Completions | awk '{ print $2 }')
    count=$(kubectl get pods | grep Completed | wc -l)

    if [ $count -eq $target ]; then
        line0="Test complete!"
        line1=$(kubectl describe job video-worker | grep Start | awk '$1=$1')
        line2=$(kubectl describe job video-worker | grep Completed | awk '$1=$1')
        message=$(printf "$line0\n$line1\n$line2")
        ./tg_send_message.sh $TG_TOKEN $TG_CHAT_ID "$message" &>/dev/null
        exit
    fi
    sleep 1
done
