FROM alpine
LABEL maintainer "Jacques Supcik <jacques.supcik@hefr.ch>"

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    newlib-arm-none-eabi \
    make cmake \
    curl unzip git

# Get the latest libbbb from gitlab
WORKDIR /tmp
RUN curl -L https://gitlab.forge.hefr.ch/embsys/libbbb/-/jobs/artifacts/master/download?job=build --output t.zip
RUN unzip t.zip
WORKDIR /tmp/build
RUN tar zxvf libbbb-*-arm-none-eabi.tar.gz

# Install libbbb into standard directories
WORKDIR /
RUN cp -l /tmp/build/libbbb-*-arm-none-eabi/include/* /usr/arm-none-eabi/include/
RUN cp -l /tmp/build/libbbb-*-arm-none-eabi/lib/* /usr/arm-none-eabi/lib/

# Copy makefiles, headers and library to /se12/bbb for compatibility
COPY make.d /se12/bbb/make
RUN mkdir /se12/bbb/source
RUN cp -l /tmp/build/libbbb-*-arm-none-eabi/include/* /se12/bbb/source
RUN cp -l /tmp/build/libbbb-*-arm-none-eabi/lib/* /se12/bbb/source
ENV LMIBASE="/se12"

# cleanup
RUN rm -Rf /tmp/t.zip /tmp/build
