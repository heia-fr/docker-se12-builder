FROM ubuntu
LABEL maintainer "Jacques Supcik <jacques.supcik@hefr.ch>"

ARG LIBBBB_VERSION="1.1.0"
ARG MAKEFILES_VERSION="1.0.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libnewlib-arm-none-eabi \
    git zip unzip cmake \
&& rm -rf /var/lib/apt/lists/*

ADD libbbb-${LIBBBB_VERSION}-arm-none-eabi.tar.gz /usr/local

# Copy makefiles, headers and library to /se12/bbb for compatibility
ADD makefiles-${MAKEFILES_VERSION}.tar.gz /se12/bbb
RUN mkdir /se12/bbb/source
RUN cp -l /usr/local/libbbb-${LIBBBB_VERSION}-arm-none-eabi/include/* /se12/bbb/source
RUN cp -l /usr/local/libbbb-${LIBBBB_VERSION}-arm-none-eabi/lib/* /se12/bbb/source
ENV LMIBASE="/se12/bbb"
