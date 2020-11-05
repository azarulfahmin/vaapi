FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y mesa-va-drivers
RUN apt-get install -y libdrm-dev
RUN apt-get install -y vainfo
RUN apt-get install -y git build-essential gcc make yasm autoconf automake cmake libtool checkinstall wget software-properties-common pkg-config libmp3lame-dev libunwind-dev zlib1g-dev libssl-dev
RUN apt-get update \
    && apt-get clean \
    && apt-get install -y --no-install-recommends libc6-dev libgdiplus wget software-properties-common
RUN mkdir /var/run/sshd
RUN mkdir /video
ADD RW20seconds_2.mp4 /video
WORKDIR /video
RUN pwd
RUN echo 'root:Intel123!' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN export GST_VAAPI_ALL_DRIVERS=1
RUN export LIBVA_DRIVER_NAME=iHD
RUN export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
RUN cd ~
RUN wget https://www.ffmpeg.org/releases/ffmpeg-4.0.2.tar.gz
RUN tar -xzf ffmpeg-4.0.2.tar.gz 
RUN cd ffmpeg-4.0.2
RUN ls
RUN ./ffmpeg-4.0.2/configure --enable-gpl --enable-libmp3lame --enable-decoder=mjpeg,png --enable-encoder=png
RUN make
RUN make install
WORKDIR /video
RUN ffmpeg -i RW20seconds_2.mp4 -ss 00:00:50.0 -codec copy -t 20 output.mp4
RUN ls
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
