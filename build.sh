#!/bin/bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# shellcheck source=env
. "$SCRIPT_DIR/env"

DOCKERFILE="$SCRIPT_DIR/Dockerfile-Ubuntu"
IMAGE_NAME="$USERNAME/$IMAGE"
BUILD_CONTEXT_DIR="$SCRIPT_DIR"
BUILD_DATE="$(date -Iseconds)"
BUILD_HOST="$(hostname)"

build_image() {
    docker build \
        --build-arg BUILD_CONTEXT_DIR="$BUILD_CONTEXT_DIR" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg BUILD_HOST="$BUILD_HOST" \
        "$@" \
        -f "$DOCKERFILE" \
        "$SCRIPT_DIR"
}

# First build, so we can run svn and detect the installed version.
build_image -t "$IMAGE_NAME:latest"

SVN_VERSION_ECHO="$(docker run --rm "$IMAGE_NAME:latest" svn --version | head -1)"
echo "$SVN_VERSION_ECHO"

SVN_VERSION="$(echo "$SVN_VERSION_ECHO" | cut -d" " -f3)"
echo "$SVN_VERSION" > "$SCRIPT_DIR/VERSION"
echo "Built svn version '$SVN_VERSION'"

# Rebuild with the detected SVN version as image metadata and as a tag.
build_image \
    --build-arg SVN_VERSION="$SVN_VERSION" \
    -t "$IMAGE_NAME:latest" \
    -t "$IMAGE_NAME:$SVN_VERSION"
