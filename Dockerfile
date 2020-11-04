FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install vainfo -y && \
    apt-get install ssh -y && \
    systemctl ssh start && \
    systemctl ssh enable

EXPOSE 22

CMD vainfo > ~/result.txt
