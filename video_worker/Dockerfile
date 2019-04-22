from ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common ffmpeg curl ca-certificates amqp-tools python \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY ./worker.sh /worker.sh
RUN chmod a+x /worker.sh

CMD  /usr/bin/amqp-consume --url=$BROKER_URL -q $QUEUE_NAME -c 1 /worker.sh
