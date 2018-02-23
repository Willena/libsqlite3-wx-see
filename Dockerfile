FROM debian:8.0

RUN apt-get update \
&& apt-get -y install \
    wget \
    build-essential \
    libc6-dev \
    gcc-multilib \
    g++-multilib

ENTRYPOINT ["/bin/sh"]
