#!/bin/bash

re='^[0-9]+$'

if [[ -z $1 ]]; then
   echo "No argument provided! A number is required!"
   exit 1
elif ! [[ $1 =~ $re ]] ; then
   echo "Not a valid number! A number is required!"
   exit 1
fi

for i in `seq 1 $1`; do
	echo "/usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b "video${i}.mp4""
    /usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b "video${i}.mp4"
done