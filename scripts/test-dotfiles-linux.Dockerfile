FROM ubuntu

RUN apt-get update &&\
    apt-get install -qqy curl sudo && \
    adduser --shell /bin/bash --uid 1000  --disabled-login  --gecos "" ubuntu && \    
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/0-ubuntu


USER 1000
WORKDIR /home/ubuntu
VOLUME /home/ubuntu/.dotfiles.git

