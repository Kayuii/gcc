FROM debian:stretch as builder
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list

ENV DEBIAN_FRONTEND=noninteractive
#install dependences:
RUN dpkg --add-architecture i386 && apt-get update 
RUN export DEBIAN_FRONTEND=noninteractive \
    &&  apt-get install -y --no-install-recommends apt-utils \ 
    && apt-get install -y \
    python \
    python3 \
    make \
    zlib1g-dev \ 
    tar \
    xinetd \
    build-essential \
    gcc \
    sudo \
    tofrodos \
    iproute2 \
    gawk \
    net-tools \
    expect \
    libncurses5-dev \
    tftpd \
    libssl-dev \
    flex \
    bison \
    libselinux1 \
    gnupg \
    wget \
    socat \
    gcc-multilib \
    libsdl1.2-dev \
    libglib2.0-dev \
    lib32z1-dev \
    zlib1g:i386 \
    libgtk2.0-0 \
    screen \
    pax \
    diffstat \
    xvfb \
    xterm \
    texinfo \
    gzip \
    unzip \
    cpio \
    chrpath \
    autoconf \
    lsb-release \
    libtool \
    libtool-bin \
    kmod \
    locales\
    locales-all\
    git 

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_ALL=C

# Install bash4.3 to fit wired vivado software && Replace the bash
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/b/bash/bash_4.3-14ubuntu1_amd64.deb  \
    && apt-get install ./bash_4.3-14ubuntu1_amd64.deb -y --allow-downgrades \
    && rm ./bash_4.3-14ubuntu1_amd64.deb \
    && rm /bin/sh \
    && ln -s /bin/bash /bin/sh

RUN locale-gen en_US.UTF-8 && update-locale

ARG VERSION=2012.9
ARG FILE=xilinx-2012.09-104-arm-xilinx-linux-gnueabi.bin

ADD accept-eula.sh /
ADD sdk/${FILE} /

RUN chmod a+x /${FILE}  \
    && mkdir -p /opt/xilinux/  \
    && chmod 777 /tmp \
    && cd /tmp  \
    && /accept-eula.sh /${FILE} /opt/xilinux/ \
    && rm -f /${FILE} /accept-eula.sh \
    && cd /opt/xilinux/ \
    && rm -rf jre share uninstall Uninstall* README*

FROM kayuii/gcc:i386

COPY --from=builder /opt/xilinux/ /usr/local/xilinux/

RUN ln -sfn /usr/local/xilinux/bin/* /usr/local/bin/ 

WORKDIR /opt/