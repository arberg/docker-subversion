#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

docker compose -f "$SCRIPT_DIR/compose.yaml" up -d
