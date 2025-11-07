#!/bin/bash

set -e
cd "${BUILD_DIR}/FFmpeg"
# Use OUTPUT_DIR from environment if set, otherwise default to BUILD_DIR/output
OUTPUT_DIR="${OUTPUT_DIR:-${BUILD_DIR}/output}"

# Clean previous builds
echo "Cleaning previous builds..."
make distclean 2>/dev/null || true

# Detect number of CPU cores
if command -v nproc &> /dev/null; then
    NPROC=$(nproc)
else
    # macOS uses sysctl
    NPROC=$(sysctl -n hw.ncpu)
fi

# Configure FFmpeg for static library builds
echo "Configuring FFmpeg..."

# Set platform-specific linker flags
if [ "${NATIVE_BUILD}" = "1" ] && [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS-specific configuration
    echo "Using macOS-specific build configuration..."
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
        --extra-cxxflags="-fPIC -DPIC"
else
    # Linux configuration with GNU ld flags
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
fi

# Build FFmpeg
echo "Building FFmpeg (this may take a while)..."
make -j${NPROC}

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
