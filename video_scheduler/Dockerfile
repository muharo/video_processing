FROM ubuntu:18.04

RUN apt-get clean && apt-get update && \
    apt-get install -y software-properties-common ffmpeg curl ca-certificates amqp-tools python dnsutils locales vim \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
RUN echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN echo "export LANG=en_US.UTF-8" >> ~/.bashrc
RUN echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc

RUN mkdir /utils
COPY utils/* /utils/
RUN chmod a+x /utils/*
WORKDIR /utils

CMD /usr/bin/amqp-declare-queue --url=$BROKER_URL -q $QUEUE_NAME -d && exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"