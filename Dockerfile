FROM ubuntu:latest
ARG build_secret_location=http://secrets-server/secrets.txt
ADD sources.list /etc/apt/sources.list

RUN set -e && \
    apt update && \
    apt -qqy install sudo wget && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
ENV PROJ_DIR=/home/pcf
WORKDIR /home/pcf

RUN set -e &&\
    eval $(wget -qO- $build_secret_location) && \
    wget -qO- "${GIST_URL}/raw/jumpbox-init.sh?$RANDOM" | bash && \
    sudo rm -rf /var/lib/apt/lists/* 

VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
