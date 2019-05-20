#!/bin/bash

echo ""
read -p "Number of tasks: " tasks
read -p "Percentage of high consuming tasks: " percentage
read -p "Stage1 parallelism: " stage1
read -p "Stage2 parallelism: " stage2
echo ""
export tasks
export parallelism=$stage1
cat video_worker.template | envsubst > video_worker.yaml

start=`date +%s`
kubectl create -f video_worker.yaml

# wait for certain number of tasks to complete
# before starting the second job
while :
do
    sleep 1
    count=$(kubectl get pods | grep Completed | wc -l)
    if [ $count -eq $((tasks*percentage/100)) ]; then
        break
    fi
done

echo "Stage1 complete. Increasing parallelism from $stage1 to $stage2."

export parallelism=$stage2
cat video_worker.template | envsubst > video_worker.yaml

kubectl apply -f video_worker.yaml 2>/dev/null

# wait for all jobs to complete
while :
do
    sleep 1
    count=$(kubectl get pods | grep Completed | wc -l)
    if [ $count -eq $tasks ]; then
        break
    fi
done

end=`date +%s`
runtime=$((end-start))

echo "Stage2 complete."
echo "Jobs completed in $runtime seconds."
echo ""