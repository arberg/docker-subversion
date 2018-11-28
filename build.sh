#!/bin/bash
set -ex

. env.sh

# docker build -f Dockerfile-Alpine -t $USERNAME/$IMAGE:latest-alpine .

docker build -f Dockerfile-Ubuntu -t $USERNAME/$IMAGE:latest .


SVN_VERSION_ECHO=$(docker run --rm $USERNAME/$IMAGE:latest svn --version | head -1)
echo "$SVN_VERSION_ECHO"
SVN_VERSION_ECHO=$(echo "$SVN_VERSION_ECHO" | cut -d" " -f3)
echo $SVN_VERSION_ECHO > VERSION
echo "Built svn version '$SVN_VERSION_ECHO'"
