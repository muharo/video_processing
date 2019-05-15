#!/bin/bash

read line

path="/video"
input="${path}/input/${line}"
output="${path}/output/${line}"
processing_log="${path}/processing.log"
execution_log="${path}/execution.log"

echo "Dequeue: $line" >> $processing_log

start=`date +%s`

encoding=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $input)
bitrate=$(ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 $input)
duration=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $input | sed 's/[.].*//')
frames=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=noprint_wrappers=1:nokey=1 $input)
resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $input)
size=$(du -b $input | awk '{ print $1 }')

ffmpeg -i $input -vf scale=320:240 $output

end=`date +%s`
runtime=$((end-start))

# Size | Duration | Frames | Bitrate | Resolution | Runtime | Encoding | Name
echo "$size | $duration | $frames | $bitrate | $resolution | $runtime | $encoding | $line" >> $execution_log
