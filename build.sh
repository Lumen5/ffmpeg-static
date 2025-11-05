#!/bin/bash

set -e

PLATFORM=linux/amd64 ./build-for-platform.sh
PLATFORM=linux/arm64 ./build-for-platform.sh