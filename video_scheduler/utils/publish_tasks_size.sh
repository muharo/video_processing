#!/bin/bash

re='^[0-9]+$'

if [[ -z $1 ]]; then
    echo "How many messages?"
    read counter
else
    counter=$1
fi

if [[ -z $counter ]]; then
    echo "No argument provided! A number is required!"
    exit 1
elif ! [[ $counter =~ $re ]] ; then
    echo "Not a valid number! A number is required!"
    exit 1
fi

i=$counter
for file in $( ls -1rS /video/input/ ); do
    if [[ $i -gt 0 ]]; then
    	#echo "/usr/bin/amqp-publish --url=$BROKER_URL -r $QUEUE_NAME -p -b $file"
        /usr/bin/amqp-publish --url=$BROKER_URL -r $QUEUE_NAME -p -b $file
        ((i--))
    else
        break
    fi
done

echo "$counter tasks added to queue"
