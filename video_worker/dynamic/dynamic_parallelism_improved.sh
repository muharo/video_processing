#!/bin/bash

echo ""
read -p "Number of tasks: " tasks
read -p "Number of nodes: " nodes
read -p "Number of cores per node: " cores
echo ""
export tasks

# number of nodes and cores gives us the parallelism interval
parallelism_up=$((nodes*(cores+2)))
parallelism_down=$((nodes*(cores+1)))
stages=$((parallelism_up-parallelism_down+1))
stage_size=$((tasks/stages))

echo "There will be $stages stages of $stage_size videos each."
echo "The parallelism will be lowered for each stage from $parallelism_up to $parallelism_down."
echo ""

start=`date +%s`

for ((i = 1 ; i <= $stages ; i++)); do
    export parallelism=$parallelism_up
    cat video_worker.template | envsubst > video_worker.yaml
    kubectl apply -f video_worker.yaml 2>/dev/null

    while :
    do
        sleep 3
        count=$(kubectl get pods | grep Completed | wc -l)
        if [ $count -eq $((i*stage_size)) ]; then
            break
        fi
    done

    echo "$((i*stage_size)) videos are completed. Reducing parallelism from $parallelism_up to $((parallelism_up-1))"
    ((parallelism_up--))
done

end=`date +%s`
runtime=$((end-start))

echo ""
echo "Processed $tasks videos in $runtime seconds."
echo ""
