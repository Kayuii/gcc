FROM kayuii/xilinx:base as builder

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

FROM kayuii/gcc:amd64

RUN dpkg --add-architecture i386 && apt-get update \
    && apt-get install -y lib32z1 curl git cmake \
    libbz2-1.0:i386 lib32stdc++6 zlib1g:i386 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /opt/xilinux/ /usr/local/xilinux/

RUN ln -sfn /usr/local/xilinux/bin/* /usr/local/bin/ 
