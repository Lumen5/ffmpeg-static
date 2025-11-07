#!/bin/bash

set -e

# Configuration
FFMPEG_VERSION="${FFMPEG_VERSION:-n5.1.4}"
PLATFORM="${PLATFORM:linux/amd64}"
OUTPUT_DIR="$(pwd)/output/${PLATFORM}"
DOCKER_IMAGE="ffmpeg-builder:latest"

echo "============================================="
echo "FFmpeg Static Library Builder for ${PLATFORM}"
echo "============================================="
echo "FFmpeg Version: ${FFMPEG_VERSION}"
echo "Output Directory: ${OUTPUT_DIR}"
echo ""

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Check if this is a darwin (macOS) build
if [[ "${PLATFORM}" == darwin/* ]]; then
    echo "Building natively for macOS (no Docker)..."
    echo ""

    # Check for required dependencies
    if ! command -v nasm &> /dev/null; then
        echo "Error: nasm is required but not installed."
        echo "Please install it with: brew install nasm"
        exit 1
    fi

    if ! command -v yasm &> /dev/null; then
        echo "Error: yasm is required but not installed."
        echo "Please install it with: brew install yasm"
        exit 1
    fi

    # Clone FFmpeg if not already present
    if [ ! -d "FFmpeg" ]; then
        echo "Cloning FFmpeg ${FFMPEG_VERSION}..."
        git clone --depth 1 --branch ${FFMPEG_VERSION} https://github.com/FFmpeg/FFmpeg.git
    fi

    # Run the build natively
    echo "Running FFmpeg build natively..."
    BUILD_DIR="$(pwd)" OUTPUT_DIR="${OUTPUT_DIR}" NATIVE_BUILD=1 bash build-ffmpeg.sh
else
    # Build Docker image for Linux platforms
    echo "Building Docker image..."
    docker build --platform ${PLATFORM} -t "${DOCKER_IMAGE}" .

    # Run the build in Docker
    echo ""
    echo "Running FFmpeg build in Docker container..."
    docker run --platform ${PLATFORM} --rm \
        -v "$(pwd)/build-ffmpeg.sh:/build/build-ffmpeg.sh:ro" \
        -v "${OUTPUT_DIR}:/build/output" \
        -e FFMPEG_VERSION="${FFMPEG_VERSION}" \
        "${DOCKER_IMAGE}" \
        bash /build/build-ffmpeg.sh
fi

echo ""
echo "============================================="
echo "Build complete!"
echo "============================================="
echo "Static libraries (.a files) are available in:"
echo "${OUTPUT_DIR}/lib/"
echo ""
ls -lh "${OUTPUT_DIR}/lib/"*.a 2>/dev/null || echo "No .a files found"
echo ""
echo "Include headers are available in:"
echo "${OUTPUT_DIR}/include/"
