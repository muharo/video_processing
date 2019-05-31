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
elif [[ $counter -eq 0 ]]; then
    counter=$(ls $path | wc -l)
fi

publish_tasks(){
    i=$counter
    for file in $list; do
        if [[ $i -gt 0 ]]; then
            /usr/bin/amqp-publish --url=$BROKER_URL -r $QUEUE_NAME -p -b $file
            ((i--))
        else
            break
        fi
    done
}

if [[ -z $2 ]]; then

    title="Select tasks arrangement algorithm."
    prompt="Pick an option:"
    options=("FIFO" "SFF" "LFF" "SFLF")

    echo ""
    echo "$title"
    echo ""

    PS3="$prompt "
    select opt in "${options[@]}" "Cancel"; do

        case "$REPLY" in

        1)
            algorithm="FIFO"
            break
            ;;
        2)
            algorithm="SFF"
            break
            ;;
        3)
            algorithm="LFF"
            break
            ;;
        4)
            algorithm="SFLF"
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

else
    algorithm=$2
fi

case "$algorithm" in

    FIFO)
        echo ""
        echo "Ordering videos alphabetically..."
        list=$(ls -1v $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        ;;
    SFF)
        echo ""
        echo "Ordering videos by size (ascending)..."
        list=$(ls -1rS $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        ;;
    LFF)
        echo ""
        echo "Ordering videos by size (descending)..."
        list=$(ls -1S $path)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        ;;
    SFLF)
        echo ""
        echo "Ordering videos by size (small file, large file)..."
        j=0
        up=($(ls -1rS $path | head --lines=$((counter/2))))
        down=($(ls -1S $path | head --lines=$((counter/2))))
        list=$(for i in "${!up[@]}"; do echo "${up[i]}"; echo "${down[i]}"; done)
        publish_tasks
        echo "$counter tasks were added to queue."
        echo ""
        ;;
    *)
        echo ""
        echo "Invalid algorithm. Exit!"
        exit 1
        ;;
esac