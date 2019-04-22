FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common ffmpeg curl ca-certificates amqp-tools python dnsutils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /utils
COPY utils/* /utils/

/usr/bin/amqp-declare-queue --url=$BROKER_URL -q $QUEUE_NAME -d

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"