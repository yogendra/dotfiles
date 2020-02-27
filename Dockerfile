FROM ubuntu:latest
ARG build_secret_location=http://secrets-server/config/secrets.sh
ARG OM_PIVNET_TOKEN
ARG git_repo=yogendra/dotfiles

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
    eval $(wget -qO- $build_secret_location) && \
    wget -qO- "https://raw.githubusercontent.com/$git_repo/master/scripts/pcf-jumpbox-init.sh?$RANDOM" |  bash && \
    sudo rm -rf /var/lib/apt/lists/* 


VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
