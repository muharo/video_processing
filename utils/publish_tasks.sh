#!/bin/bash

usage(){
    echo ""
    echo $1
    echo ""
    echo "Usage: $0 TASKS_NUMBER ALGORITHM"
    echo "TASKS_NUMBER - provide integer or use '0' to read the number of videos from input path"
    echo "ALGORITHM - accepted values for now are FIFO, SFF, LFF or SFLF"
    echo ""
}

re='^[0-9]+$'
array=("FIFO" "SFF" "LFF" "SFLF")

# Read tasks number and algorithm
if [[ -z $1 ]]; then   
    usage "Tasks number is mandatory."
    exit 1
elif ! [[ $1 =~ $re ]] ; then
    usage "Not a valid number! A number is required!"
    exit 1
elif [[ -z $2 ]]; then   
    usage "Algorithm is mandatory."
    exit 1
elif [[ ! "${array[@]}" =~ "$2" ]]; then
    usage "Invalid algorithm."
    exit 1
fi

echo ""
echo "Adding $1 tasks to queue using $2 algorithm..."
kubectl exec -it video-scheduler -- bash -c "/utils/publish_tasks.sh $1 $2"
echo "Done."
echo ""