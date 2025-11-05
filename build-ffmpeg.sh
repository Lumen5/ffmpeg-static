#!/bin/bash

set -e
cd "${BUILD_DIR}/FFmpeg"
OUTPUT_DIR="${BUILD_DIR}/output"

# Clean previous builds
echo "Cleaning previous builds..."
make distclean 2>/dev/null || true

# Configure FFmpeg for static library builds
echo "Configuring FFmpeg..."
./configure \
    --prefix="${OUTPUT_DIR}" \
    --disable-shared \
    --enable-static \
    --enable-gpl \
    --enable-postproc \
    --disable-programs \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --enable-pic \
    --disable-debug \
    --disable-stripping \
    --disable-asm \
    --extra-cflags="-fPIC -DPIC" \
    --extra-cxxflags="-fPIC -DPIC" \
    --extra-ldflags="-fPIC -Wl,--Bsymbolic -Wl,--allow-multiple-definition"

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
