#!/bin/bash
set -ex

. env.sh

# svn 1.10
docker build -f Dockerfile-Alpine -t $USERNAME/$IMAGE:latest-alpine .
# svn 1.9.7
docker build -f Dockerfile-Ubuntu -t $USERNAME/$IMAGE:latest .