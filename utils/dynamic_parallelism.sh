#!/bin/bash

read -p "Number of tasks: " tasks
read -p "Percentage of high consuming tasks: " percentage

counter=$((tasks*percentage/100))
parallelism=8
# echo "$counter tasks to be run as ${parallelism} parallel tasks"
cat template.txt | envsubst > video_worker_1.yml

kubectl create -f video_worker_1.yaml

# WAIT
while :
do
	count=$(kubectl get pods | grep Completed | wc -l)
	if [ $count -eq $((counter-parallelism)) ]; then
		break
	fi
	sleep 1
done

counter=$((tasks-counter))
parallelism=16
# echo "$counter tasks to be run as ${parallelism} parallel tasks"
cat template.txt | envsubst > video_worker_2.yml

kubectl create -f video_worker_2.yaml