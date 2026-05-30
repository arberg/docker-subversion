#!/usr/bin/env bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# shellcheck source=env
. "$SCRIPT_DIR/env"

docker image inspect "$USERNAME/$IMAGE:latest"
