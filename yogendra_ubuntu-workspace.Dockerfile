FROM yogendra/ubuntu:latest
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y git vim tmux 

CMD ["bash", "-l"]
