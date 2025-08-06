FROM alpine:latest as downloader
LABEL maintainer "zcsevcik@gmail.com"

# 设置架构、版本和下载URL参数，可从外部传入
ARG ARCH=aarch64
ARG GCC_VERSION=10
ARG DOWNLOAD_URL=https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add w3m wget openssl ca-certificates && \
    GCCARM_LINK="$(w3m -o display_link_number=1 -dump "${DOWNLOAD_URL}" | \
    grep -m1 "/gcc-arm-${GCC_VERSION}.*-${ARCH}.*arm-none-linux-gnueabihf\.tar\.xz\?" | \
    sed -e 's/^\[[0-9]\+\] //')" && \
    wget -O /tmp/gcc-arm-${ARCH}-arm-linux-gnueabihf.tar.xz ${GCCARM_LINK}

FROM ubuntu:20.04

LABEL maintainer "577738@qq.com"

# 设置环境变量避免交互提示
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 设置架构和版本参数，可从外部传入
ARG ARCH=aarch64
ARG GCC_VERSION=10

COPY --from=downloader /tmp/gcc-arm-${ARCH}-arm-linux-gnueabihf.tar.xz /tmp/gcc-arm-${ARCH}-arm-linux-gnueabihf.tar.xz

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y \
    autoconf automake libtool pkg-config make cmake git curl \
     wget tar xz-utils && \
    tar xf /tmp/gcc-arm-${ARCH}-arm-linux-gnueabihf.tar.xz --strip-components=1 -C /usr/local/ && \
    rm -rf /tmp/gcc-arm-${ARCH}-arm-linux-gnueabihf.tar.xz && \
    cd /usr/local/bin && \
    ls | awk -F "arm-none-linux-gnueabihf-" -v version="$GCC_VERSION" '{print "ln -s", $0,"arm-"version"-linux-gnueabihf-"$2}' | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/
