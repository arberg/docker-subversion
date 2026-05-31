#!/bin/bash
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

cd "$SCRIPT_DIR"

# ensure we're up to date, including tags
git pull --tags

./build.sh

# load env after building; build updates VERSION
# shellcheck source=env
. "$SCRIPT_DIR/env"

VERSION="$(cat "$SCRIPT_DIR/VERSION")"
IMAGE_NAME="$USERNAME/$IMAGE"

NORMAL_LATEST="$IMAGE_NAME:latest"
NORMAL_VERSION="$IMAGE_NAME:$VERSION"
ISOLATED_LATEST="$IMAGE_NAME:latest-isolated"
ISOLATED_VERSION="$IMAGE_NAME:$VERSION-isolated"

remote_docker_tag_exists() {
    docker manifest inspect "$1" >/dev/null 2>&1
}

ensure_git_release() {
    git add -A

    # Commit only if there are staged/working-tree changes.
    git diff-index --quiet HEAD || git commit -m "version $VERSION"

    # Always recreate the local Git tag so it points at this release commit.
    # -f intentionally overwrites an existing tag with the same VERSION.
    git tag -fa "$VERSION" -m "version $VERSION"

    git push
    # Force-push this release tag only, so the remote tag is overwritten too.
    git push --force origin "refs/tags/$VERSION"
}

release_docker_images() {
    # Always push latest tags. They intentionally move.
    docker push "$NORMAL_LATEST"
    docker push "$ISOLATED_LATEST"

    # Push version tags if they are not already present in the registry.
    # This fixes the case where VERSION was already updated by a manual build,
    # but the Docker release was never pushed.
#    if remote_docker_tag_exists "$NORMAL_VERSION"; then
#        echo "Docker tag $NORMAL_VERSION already exists in registry."
#    else
        docker push "$NORMAL_VERSION"
#    fi

#    if remote_docker_tag_exists "$ISOLATED_VERSION"; then
#        echo "Docker tag $ISOLATED_VERSION already exists in registry."
#    else
        docker push "$ISOLATED_VERSION"
#    fi
}

set -ex
ensure_git_release
release_docker_images
set +x
