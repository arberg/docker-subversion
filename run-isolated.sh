#!/usr/bin/env bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=env
. "$SCRIPT_DIR/env-run"

IMAGE_NAME="$USERNAME/$IMAGE:latest-isolated"

mkdir -p "$HOST_SVN_DIR"

if ! docker network inspect "$NETWORK_ISOLATED_NAME" >/dev/null 2>&1; then
    docker network create \
        --driver bridge \
        --subnet "$NETWORK_ISOLATED_SUBNET" \
        "$NETWORK_ISOLATED_NAME"
fi

docker rm -f "$DOCKER_NAME" >/dev/null 2>&1 || true

docker run -d \
    --name "$DOCKER_NAME" \
    --restart unless-stopped \
    --network "$NETWORK_ISOLATED_NAME" \
    --security-opt no-new-privileges:true \
    -p "$HOST_PORT:3690" \
    -v "$HOST_SVN_DIR:/svn" \
    -v "$HOST_CONFIG_DATA_DIR/etc/svn_sasldb:/etc/svn_sasldb" \
    -v "$HOST_CONFIG_DATA_DIR/etc/sasl2:/etc/sasl2" \
    -v "/etc/timezone:/etc/timezone:ro" \
    -v "/etc/localtime:/etc/localtime:ro" \
    "$IMAGE_NAME"
