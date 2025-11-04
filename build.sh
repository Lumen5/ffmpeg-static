#!/bin/bash

set -e

# Configuration
FFMPEG_VERSION="${FFMPEG_VERSION:-n7.1}"
OUTPUT_DIR="$(pwd)/output"
DOCKER_IMAGE="ffmpeg-builder:latest"

echo "============================================="
echo "FFmpeg Static Library Builder for linux/amd64"
echo "============================================="
echo "FFmpeg Version: ${FFMPEG_VERSION}"
echo "Output Directory: ${OUTPUT_DIR}"
echo ""

# Build Docker image
echo "Building Docker image..."
docker build --platform linux/amd64 -t "${DOCKER_IMAGE}" .

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Run the build in Docker
echo ""
echo "Running FFmpeg build in Docker container..."
docker run --platform linux/amd64 --rm \
    -v "$(pwd)/build-ffmpeg.sh:/build/build-ffmpeg.sh:ro" \
    -v "${OUTPUT_DIR}:/build/output" \
    -e FFMPEG_VERSION="${FFMPEG_VERSION}" \
    "${DOCKER_IMAGE}" \
    bash /build/build-ffmpeg.sh

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
