#!/bin/bash

set -e

rm -rf output/
PLATFORM=linux/amd64 ./build-for-platform.sh
PLATFORM=linux/arm64 ./build-for-platform.sh
PLATFORM=darwin/arm64 ./build-for-platform.sh