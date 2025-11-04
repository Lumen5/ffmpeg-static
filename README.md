# FFmpeg Static Library Builder for linux/amd64

This project builds FFmpeg static libraries (`.a` files) for linux/amd64 architecture from source. It uses Docker to provide a consistent cross-platform build environment, allowing you to build Linux binaries from macOS.

## Prerequisites

- Docker (with support for linux/amd64 platform)
- Bash shell
- Internet connection (to clone FFmpeg repository)

## Quick Start

Simply run the build script:

```bash
./build.sh
```

This will:
1. Build a Docker image with all necessary build dependencies
2. Clone the FFmpeg repository
3. Compile FFmpeg as static libraries
4. Output the `.a` files to the `output/lib/` directory

## Generated Libraries

The build process will generate the following static libraries:

- `libavcodec.a` - Audio/video codec library
- `libavdevice.a` - Device handling library
- `libavfilter.a` - Audio/video filtering library
- `libavformat.a` - Audio/video container format library
- `libavutil.a` - Utility library
- `libswresample.a` - Audio resampling library
- `libswscale.a` - Video scaling and color conversion library

All libraries will be located in `output/lib/` after a successful build.

Header files will be in `output/include/`.

## Custom FFmpeg Version

You can specify a different FFmpeg version by setting the `FFMPEG_VERSION` environment variable:

```bash
# Build a specific release version
FFMPEG_VERSION=n6.1 ./build.sh

# Build from master branch
FFMPEG_VERSION=master ./build.sh

# Build from a specific commit
FFMPEG_VERSION=abc123def ./build.sh
```

Default version: `n7.1` (FFmpeg 7.1)

## Build Configuration

The libraries are built with the following configuration:

- **Static libraries only** (no shared libraries)
- **Position Independent Code (PIC)** enabled
- **No programs** (ffmpeg, ffprobe, etc.)
- **No documentation**
- **Debug symbols disabled**
- **Optimized for library usage**

## Output Structure

After building, your directory will look like:

```
beamcoder-ffmpeg-static/
├── build.sh              # Main build script
├── build-ffmpeg.sh       # Docker build script
├── Dockerfile            # Docker image definition
├── README.md            # This file
└── output/
    ├── include/         # FFmpeg header files
    │   ├── libavcodec/
    │   ├── libavdevice/
    │   ├── libavfilter/
    │   ├── libavformat/
    │   ├── libavutil/
    │   ├── libswresample/
    │   └── libswscale/
    └── lib/             # Static library files
        ├── libavcodec.a
        ├── libavdevice.a
        ├── libavfilter.a
        ├── libavformat.a
        ├── libavutil.a
        ├── libswresample.a
        └── libswscale.a
```

## Clean Build

To perform a clean build, remove the output directory:

```bash
rm -rf output/
./build.sh
```

## Platform Notes

- **Target Platform**: linux/amd64
- **Build Platform**: Can be run from macOS (including M1/M2/M3/M4) or Linux
- **Docker Platform**: The build uses `--platform linux/amd64` to ensure consistent output regardless of host architecture

## Troubleshooting

### Docker Platform Issues

If you encounter platform-related errors, ensure Docker Desktop has support for linux/amd64 enabled. On Apple Silicon Macs, this requires Rosetta 2:

```bash
softwareupdate --install-rosetta
```

### Build Failures

If the build fails:

1. Check Docker is running: `docker ps`
2. Remove cached containers: `docker system prune`
3. Try a clean build by removing `output/` directory

### Slow Builds

The first build will take longer as it needs to:
- Download the Docker base image
- Install build dependencies
- Clone the FFmpeg repository
- Compile all libraries

Subsequent builds will be faster if you keep the `output/` directory.

## License

This build script is provided as-is. FFmpeg itself is licensed under LGPL 2.1+ or GPL 2+ depending on configuration. See the [FFmpeg License](https://ffmpeg.org/legal.html) for details.
