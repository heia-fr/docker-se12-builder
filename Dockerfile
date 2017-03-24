FROM ubuntu
LABEL maintainer "Jacques Supcik <jacques.supcik@hefr.ch>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libnewlib-arm-none-eabi \
    python3-flask \
    zip unzip \
&& rm -rf /var/lib/apt/lists/*

COPY se12/bbb/source /bbb/source
COPY se12/bbb/make   /bbb/make
COPY se-builder.py   /app/se-builder.py

ENV LMIBASE=""
RUN cd /bbb/source && make clean all

EXPOSE 8080

ENTRYPOINT ["python3", "/app/se-builder.py"]
