#!/bin/bash

path="/video/input"
re='^[0-9]+$'

# Read tasks number
if [[ -z $1 ]]; then
    echo ""
    echo "How many tasks to be queued?"
    read counter
else
    counter=$1
fi

if [[ -z $counter ]]; then
    echo "No argument provided! A number is required!"
    echo ""
    exit 1
elif ! [[ $counter =~ $re ]] ; then
    echo "Not a valid number! A number is required!"
    echo ""
    exit 1
fi

title="Select tasks arrangement algorithm."
prompt="Pick an option:"
options=("Alpha" "SFF" "LFF" "SFLF")

publish_tasks(){
    i=$counter
    for file in $list; do
        if [[ $i -gt 0 ]]; then
            echo "/usr/bin/amqp-publish --url=$BROKER_URL -r $QUEUE_NAME -p -b $file"
            #/usr/bin/amqp-publish --url=$BROKER_URL -r $QUEUE_NAME -p -b $file
            ((i--))
        else
            break
        fi
    done
}


echo ""
echo "$title"
echo ""

PS3="$prompt "
select opt in "${options[@]}" "Cancel"; do

    case "$REPLY" in

    1)
        echo ""
        echo "Ordering videos alphabetically..."
        list=$(ls -1v $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        break
        ;;
    2)
        echo ""
        echo "Ordering videos by size (ascending)..."
        list=$(ls -1rS $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        break
        ;;
    3)
        echo ""
        echo "Ordering videos by size (descending)..."
        list=$(ls -1S $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        break
        ;;
    4)
        echo ""
        echo "Ordering videos by size (small file, large file)..."
        j=0
        up=($(ls -1rS $path | head --lines=$((counter/2))))
        down=($(ls -1S $path | head --lines=$((counter/2))))
        list=$(for i in "${!up[@]}"; do echo "${up[i]}"; echo "${down[i]}"; done)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        break
        ;;

    5)
        echo ""
        echo "Goodbye!"
        echo ""
        exit 0
        ;;
    *)
        echo ""
        echo "Invalid option. Try again!"
        continue
        ;;
    esac
done


