FROM alpine:latest as downloader
LABEL maintainer "zcsevcik@gmail.com"

# 设置架构、版本、目标三元组和下载URL参数，可从外部传入
ARG ARCH=aarch64
ARG GCC_VERSION=10
ARG TARGET_TRIPLET=aarch64-none-linux-gnu
ARG DOWNLOAD_URL=https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add w3m wget openssl ca-certificates && \
    if [ "$GCC_VERSION" -ge 11 ]; then \
        echo "使用新版本文件名格式 (arm-gnu-toolchain)"; \
        GCCARM_LINK="$(w3m -o display_link_number=1 -dump "${DOWNLOAD_URL}" | \
        grep -m1 "/arm-gnu-toolchain-${GCC_VERSION}.*-${ARCH}.*${TARGET_TRIPLET}\.tar\.xz\?" | \
        sed -e 's/^\[[0-9]\+\] //')"; \
    else \
        echo "使用旧版本文件名格式 (gcc-arm)"; \
        GCCARM_LINK="$(w3m -o display_link_number=1 -dump "${DOWNLOAD_URL}" | \
        grep -m1 "/gcc-arm-${GCC_VERSION}.*-${ARCH}.*${TARGET_TRIPLET}\.tar\.xz\?" | \
        sed -e 's/^\[[0-9]\+\] //')"; \
    fi && \
    echo "找到的下载链接: $GCCARM_LINK" && \
    wget -O /tmp/gcc-${ARCH}-${TARGET_TRIPLET}.tar.xz ${GCCARM_LINK}

FROM ubuntu:16.04

LABEL maintainer "577738@qq.com"

# 设置环境变量避免交互提示
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 设置架构、版本和目标三元组参数，可从外部传入
ARG ARCH=aarch64
ARG GCC_VERSION=10
ARG TARGET_TRIPLET=aarch64-none-linux-gnu

COPY --from=downloader /tmp/gcc-${ARCH}-${TARGET_TRIPLET}.tar.xz /tmp/gcc-${ARCH}-${TARGET_TRIPLET}.tar.xz

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y \
    autoconf automake libtool pkg-config make cmake git curl \
     wget tar xz-utils && \
    tar xf /tmp/gcc-${ARCH}-${TARGET_TRIPLET}.tar.xz --strip-components=1 -C /usr/local/ && \
    rm -rf /tmp/gcc-${ARCH}-${TARGET_TRIPLET}.tar.xz && \
    cd /usr/local/bin && \
    ls | awk -F "${TARGET_TRIPLET}-" -v version="$GCC_VERSION" -v triplet="$TARGET_TRIPLET" '{gsub("none", version, triplet); print "ln -s", $0, triplet"-"$2}' | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/
