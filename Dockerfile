FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install vainfo -y && \
    apt-get install openssh-server -y && \
    systemctl enable ssh && \
    systemctl start ssh

EXPOSE 22

CMD vainfo > ~/result.txt
