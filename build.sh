#!/bin/bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# shellcheck source=env
. "$SCRIPT_DIR/env"

DOCKERFILE="Dockerfile-Ubuntu"
IMAGE_NAME="$USERNAME/$IMAGE"
BUILD_CONTEXT_DIR="$(pwd -P)"
BUILD_DATE="$(date -Iseconds)"
BUILD_HOST="$(hostname)"

build_image() {
    docker build \
        --build-arg BUILD_CONTEXT_DIR="$BUILD_CONTEXT_DIR" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg BUILD_HOST="$BUILD_HOST" \
        "$@" \
        -f "$DOCKERFILE" \
        .
}

build_image -t "$IMAGE_NAME:latest"

SVN_VERSION_ECHO="$(docker run --rm "$IMAGE_NAME:latest" svn --version | head -1)"
echo "$SVN_VERSION_ECHO"

SVN_VERSION="$(echo "$SVN_VERSION_ECHO" | cut -d" " -f3)"
echo "$SVN_VERSION" > VERSION
echo "Built svn version '$SVN_VERSION'"

build_image \
    --build-arg SVN_VERSION="$SVN_VERSION" \
    -t "$IMAGE_NAME:latest" \
    -t "$IMAGE_NAME:$SVN_VERSION"