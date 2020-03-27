FROM ubuntu:latest
ARG build_secret_location=http://secrets-server/secrets.sh

ADD config/sources.list /etc/apt/sources.list

RUN set -e && \
    apt update && \
    apt -qqy install wget sudo && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
ENV PROJ_DIR=/home/pcf
WORKDIR /home/pcf

RUN set -e &&\
    echo 0 && \
    eval "$(wget -qO- $build_secret_location)" && \ 
    echo 1 && \
    wget -qO- "https://raw.githubusercontent.com/$GITHUB_REPO/master/scripts/pcf-jumpbox-init.sh?$RANDOM" |  bash && \
    echo 3 && \
    sudo rm -rf /var/lib/apt/lists/* 


VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
