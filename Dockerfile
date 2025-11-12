FROM debian:bookworm-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    yasm \
    nasm \
    pkg-config \
    autoconf \
    automake \
    libtool \
    wget \
    ca-certificates \
    libvpx-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV FFMPEG_VERSION=n5.1.4
ENV BUILD_DIR=/build

RUN git clone --depth 1 --branch ${FFMPEG_VERSION} https://github.com/FFmpeg/FFmpeg.git

# The build script will be mounted and run from the host
