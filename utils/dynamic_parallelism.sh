#!/bin/bash

read -p "Number of tasks: " tasks
read -p "Percentage of high consuming tasks: " percentage

export counter=$((tasks*percentage/100))
export parallelism=9
cat video_worker.template | envsubst > video_worker_1.yaml

start=`date +%s`
kubectl create -f video_worker_1.yaml

# wait for certain number of tasks to complete
# before starting the second job
while :
do
	sleep 1
	count=$(kubectl get pods | grep Completed | wc -l)
	if [ $count -eq $((counter-parallelism)) ]; then
		break
	fi
done

export counter=$((tasks-counter))
export parallelism=15
cat video_worker.template | envsubst > video_worker_2.yaml

kubectl create -f video_worker_2.yaml

# wait for all jobs to complete
while :
do
	sleep 1
	count=$(kubectl get pods | grep Completed | wc -l)
	if [ $count -eq $counter ]; then
		break
	fi
done

end=`date +%s`
runtime=$((end-start))

echo "Jobs completed in $runtime seconds."