FROM kayuii/alpine-glibc:v2.23 as downloader
LABEL maintainer "zcsevcik@gmail.com"

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add --virtual build-dependencies w3m wget openssl ca-certificates tar xz && \
    GCCARM_LINK="$(w3m -o display_link_number=1 -dump 'https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads' | \
    grep -m1 '/gcc-arm-9.*-x86_64.*arm-none-linux-gnueabihf\.tar\.xz\?' | \
    sed -e 's/^\[[0-9]\+\] //')" && \
    wget -O /tmp/gcc-arm-x86_64_arm-linux-gnueabihf.tar.xz ${GCCARM_LINK}

FROM ubuntu:16.04

LABEL maintainer "577738@qq.com"

COPY --from=downloader /tmp/gcc-arm-x86_64_arm-linux-gnueabihf.tar.xz /tmp/gcc-arm-x86_64_arm-linux-gnueabihf.tar.xz

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y \
    autoconf automake libtool pkg-config make cmake git curl \
     wget tar xz-utils && \
    tar xf /tmp/gcc-arm-x86_64_arm-linux-gnueabihf.tar.xz --strip-components=1 -C /usr/local/ && \
    rm -rf /tmp/gcc-arm-x86_64_arm-linux-gnueabihf.tar.xz && \
    cd /usr/local/bin && \
    ls | awk -F "arm-none-linux-gnueabihf-" '{print "ln -s", $0,"arm-9-linux-gnueabihf-"$2}' | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/
