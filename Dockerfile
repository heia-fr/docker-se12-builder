FROM alpine
LABEL maintainer "Jacques Supcik <jacques.supcik@hefr.ch>"

ARG LIBBBB_VERSION="1.3.1"
ARG MAKEFILES_VERSION="1.0.0"

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    newlib-arm-none-eabi \
    make cmake \
    git

ADD libbbb-${LIBBBB_VERSION}-arm-none-eabi.tar.gz /tmp

# Install header files and library
RUN cp -l /tmp/libbbb-${LIBBBB_VERSION}-arm-none-eabi/include/* /usr/arm-none-eabi/include/
RUN cp -l /tmp/libbbb-${LIBBBB_VERSION}-arm-none-eabi/lib/* /usr/arm-none-eabi/lib/

# Copy makefiles, headers and library to /se12/bbb for compatibility
ADD makefiles-${MAKEFILES_VERSION}.tar.gz /se12/bbb
RUN mkdir /se12/bbb/source
RUN cp -l /tmp/libbbb-${LIBBBB_VERSION}-arm-none-eabi/include/* /se12/bbb/source
RUN cp -l /tmp/libbbb-${LIBBBB_VERSION}-arm-none-eabi/lib/* /se12/bbb/source
ENV LMIBASE="/se12"

# cleanup
RUN rm -Rf /tmp/libbbb-${LIBBBB_VERSION}-arm-none-eabi
