FROM ubuntu as base
RUN apt-get update &&\
    apt-get install -qqy curl sudo && \
    adduser --shell /bin/bash --uid 1000  --disabled-login  --gecos "" ubuntu && \    
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/0-ubuntu
USER 1000
WORKDIR /home/ubuntu

FROM base as stage-1
VOLUME /home/ubuntu/.dotfiles.git
VOLUME /home/ubuntu/dotfiles-init.Linux.sh

FROM base as stage-2


FROM base as stage-3

RUN curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/dotfiles-init.Linux.sh?$RANDOM  | bash
