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
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# The build script will be mounted and run from the host
