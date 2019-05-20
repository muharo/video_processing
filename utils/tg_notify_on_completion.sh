#!/bin/bash

# Check if there is any job running, otherwise exit
kubectl get job video-worker &>/dev/null
if [ $? -ne 0 ]; then
	echo "There is no job running."
	exit 1
fi

# Wait for the running job to finish, then send TG notification
while :
do
    date=$(date)
    target=$(kubectl describe job video-worker | grep Completions | awk '{ print $2 }')
    count=$(kubectl get pods | grep Completed | wc -l)

    if [ $count -eq $target ]; then
        line0="Test complete!"
        line1=$(kubectl describe job video-worker | grep Start | awk '{print $7}')
        line2=$(kubectl describe job video-worker | grep Completed | awk '{print $7}')
        line3=$(kubectl describe job video-worker | grep Completions| awk '$1=$1')
        line4=$(kubectl describe job video-worker | grep Parallelism | awk '$1=$1')                                      
        message=$(printf "$line0\nStart time: $line1\nCompleted at: $line2\n$line3\n$line4")
        ./tg_send_message.sh $TG_TOKEN $TG_CHAT_ID "$message" &>/dev/null
        exit
    fi
    sleep 1
done