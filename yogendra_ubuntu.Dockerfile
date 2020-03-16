FROM ubuntu
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y wget curl git vim tmux net-tools traceroute dnsutils

CMD ["bash", "-l"]
