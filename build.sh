#!/bin/bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# shellcheck source=env
. "$SCRIPT_DIR/env"

DOCKERFILE="$SCRIPT_DIR/Dockerfile"
IMAGE_NAME="$USERNAME/$IMAGE"
BUILD_CONTEXT_DIR="$SCRIPT_DIR"
BUILD_DATE="$(date -Iseconds)"
BUILD_HOST="$(hostname)"

echo "$IMAGE_NAME"
echo "$BUILD_CONTEXT_DIR"
echo "$BUILD_DATE"
echo "$BUILD_HOST"

build_image() {
    echo "$@"
    docker build \
        --build-arg BUILD_CONTEXT_DIR="$BUILD_CONTEXT_DIR" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg BUILD_HOST="$BUILD_HOST" \
        "$@" \
        -f "$DOCKERFILE" \
        "$SCRIPT_DIR"
}

# Temporary build for metadata extraction.
FINAL_IMAGE="$IMAGE_NAME:latest"
TMP_IMAGE="$FINAL_IMAGE"
build_image -t "$TMP_IMAGE"

SVN_VERSION_ECHO="$(docker run --rm "$TMP_IMAGE" svn --version | head -1)"
SVN_VERSION="$(echo "$SVN_VERSION_ECHO" | cut -d' ' -f3)"

OS_VERSION="$(docker run --rm "$TMP_IMAGE" sh -c '. /etc/os-release; echo "$VERSION_ID"')"
OS_CODENAME="$(docker run --rm "$TMP_IMAGE" sh -c '. /etc/os-release; echo "$VERSION_CODENAME"')"
OS_NAME="$(docker run --rm "$TMP_IMAGE" sh -c '. /etc/os-release; echo "$ID"')"

echo "$SVN_VERSION" > "$SCRIPT_DIR/VERSION"

echo "Built svn version '$SVN_VERSION'"
echo "OS: $OS_NAME $OS_VERSION ($OS_CODENAME)"

# Final build with metadata labels and version tag.
build_image \
    --build-arg SVN_VERSION="$SVN_VERSION" \
    --build-arg OS_NAME="$OS_NAME" \
    --build-arg OS_VERSION="$OS_VERSION" \
    --build-arg OS_CODENAME="$OS_CODENAME" \
    -t "$IMAGE_NAME:latest" \
    -t "$IMAGE_NAME:$SVN_VERSION"

docker image rm "$IMAGE_NAME:tmp" >/dev/null 2>&1 || true