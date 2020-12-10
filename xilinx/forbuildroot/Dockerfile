FROM kayuii/gcc:xilinux

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bc \
    binutils \
    bzip2 \
    cpio \
    gzip \
    locales \
    libncurses5-dev \
    libdevmapper-dev \
    libsystemd-dev \
    mercurial \
    whois \
    patch \
    perl \
    python \
    rsync \
    sed \
    tar \
    vim \ 
    unzip \
    bison \
    flex \
    libssl-dev \
    libfdt-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.utf8

WORKDIR /opt/