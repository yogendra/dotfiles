FROM ubuntu
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y wget curl && \
    apt autoremove & \
    rm -rf /var/lib/apt/lists/* 

CMD "bash"
