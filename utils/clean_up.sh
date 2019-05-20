#!/bin/bash

# Delete modified videos
rm -f /shared/video/output/*

# Delete execution/processing logs
rm -f /shared/video/*.log

# Delete video processing job
kubectl delete job video-worker

# Delete generate yaml files
rm -f ../video_worker/dynamic/*.yaml