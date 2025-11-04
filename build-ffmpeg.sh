#!/bin/bash

set -e

# Configuration
FFMPEG_VERSION="${FFMPEG_VERSION:-n7.1}"  # Can be a tag, branch, or commit hash
BUILD_DIR="/build"
FFMPEG_DIR="${BUILD_DIR}/FFmpeg"
OUTPUT_DIR="${BUILD_DIR}/output"

echo "============================================="
echo "Building FFmpeg ${FFMPEG_VERSION} for linux/amd64"
echo "============================================="

# Clone FFmpeg if not already cloned
if [ ! -d "${FFMPEG_DIR}" ]; then
    echo "Cloning FFmpeg repository..."
    git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git "${FFMPEG_DIR}"
fi

cd "${FFMPEG_DIR}"

# Checkout the specified version
echo "Checking out version ${FFMPEG_VERSION}..."
git fetch --all --tags
git checkout "${FFMPEG_VERSION}"

# Clean previous builds
echo "Cleaning previous builds..."
make distclean 2>/dev/null || true

# Configure FFmpeg for static library builds
echo "Configuring FFmpeg..."
./configure \
    --prefix="${OUTPUT_DIR}" \
    --disable-shared \
    --enable-static \
    --disable-programs \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --enable-pic \
    --disable-debug \
    --disable-stripping \
    --extra-cflags="-fPIC"

# Build FFmpeg
echo "Building FFmpeg (this may take a while)..."
make -j$(nproc)

# Install to output directory
echo "Installing FFmpeg libraries..."
make install

# List the generated static libraries
echo ""
echo "============================================="
echo "Build complete! Generated static libraries:"
echo "============================================="
ls -lh "${OUTPUT_DIR}/lib/"*.a

echo ""
echo "Libraries are located in: ${OUTPUT_DIR}/lib/"
echo "Headers are located in: ${OUTPUT_DIR}/include/"
