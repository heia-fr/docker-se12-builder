FROM alpine
LABEL maintainer "Jacques Supcik <jacques.supcik@hefr.ch>"

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    binutils-arm-none-eabi \
    cmake \
    curl \
    file \
    gcc-arm-none-eabi \
    git \
    make \
    newlib-arm-none-eabi \
    python3 \
    unzip

RUN pip3 install --upgrade pip && \
    pip3 install chardet cpplint

# Get the latest libbbb from gitlab
RUN cd /tmp && \
    curl -L https://gitlab.forge.hefr.ch/embsys/libbbb/-/jobs/artifacts/master/download?job=build --output t.zip && \
    unzip t.zip && \
    cd build  && \
    tar zxvf libbbb-*-arm-none-eabi.tar.gz && \
    cp -l /tmp/build/libbbb-*-arm-none-eabi/include/* /usr/arm-none-eabi/include/ && \
    cp -l /tmp/build/libbbb-*-arm-none-eabi/lib/* /usr/arm-none-eabi/lib/

# Copy makefiles, headers and library to /se12/bbb for compatibility
COPY make.d /se12/bbb/make
RUN mkdir /se12/bbb/source && \
    cp -l /tmp/build/libbbb-*-arm-none-eabi/include/* /se12/bbb/source && \
    cp -l /tmp/build/libbbb-*-arm-none-eabi/lib/* /se12/bbb/source
ENV LMIBASE="/se12"

# cleanup
RUN rm -Rf /tmp/t.zip /tmp/build

WORKDIR /se12
