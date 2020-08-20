FROM ubuntu

RUN apt-get update &&\
    apt-get install -qqy curl sudo && \
    addgroup admin && \
    adduser --shell /bin/bash --uid 1001  --disabled-login  --gecos "" ubuntu && \
    adduser ubuntu admin

USER 1001
WORKDIR /home/ubuntu

