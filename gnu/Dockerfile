FROM kayuii/gcc:base 

# install dependencies
RUN apt-get update \
    && apt-get -y install libcurl4-openssl-dev libudev-dev libusb-1.0-0-dev libncurses5-dev wget libz-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/