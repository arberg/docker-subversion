#!/bin/bash
set -ex

. env.sh

docker build -f Dockerfile-Alpine -t $USERNAME/$IMAGE:latest .
# docker build -f Dockerfile-Ubuntu -t $USERNAME/$IMAGE:latest-ubuntu .