FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common ffmpeg curl ca-certificates amqp-tools python \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /utils
COPY ../utils /utils