FROM debian:stable 

# install dependencies
RUN apt-get update \
    && apt-get -y install build-essential autoconf automake libtool pkg-config git bash curl wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
