#!/bin/bash

read line

echo "Dequeue: $line" >> /video/processing.log

start=`date +%s`

time=$(ffmpeg -i "/video/input/$line" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,// | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
size=$(du -b "/video/input/$line" | awk '{ print $1 }')

ffmpeg -i "/video/input/$line" -vf scale=320:240 "/video/output/$line"

end=`date +%s`
runtime=$((end-start))

echo "$size | $time | $runtime | $line" >> /video/execution.log
