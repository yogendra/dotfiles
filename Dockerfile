FROM ubuntu:latest
ARG build_secret_location=http://secrets-server/secrets.sh
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

RUN echo Secrets Locations: $build_secret_location // Git Repo: $git_repo
RUN eval $(wget -qO- $build_secret_location)
RUN wget -qO- "https://raw.githubusercontent.com/$git_repo/master/scripts/pcf-jumpbox-init.sh?$RANDOM" |  bash 

RUN sudo rm -rf /var/lib/apt/lists/* 


VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
