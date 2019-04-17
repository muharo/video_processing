#!/bin/bash

re='^[0-9]+$'

if [[ -z $1 ]]; then
    echo "No argument provided! A number is required!"
    exit 1
elif ! [[ $1 =~ $re ]] ; then
    echo "Not a valid number! A number is required!"
    exit 1
fi

# Publish to rabbitmq queue
for file in $( ls -1v /video/input/ ); do
    echo "/usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b $file"
    /usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b $file
done