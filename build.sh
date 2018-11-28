#!/bin/bash
set -ex

. env.sh

# docker build -f Dockerfile-Alpine -t $USERNAME/$IMAGE:latest-alpine .

docker build -f Dockerfile-Ubuntu -t $USERNAME/$IMAGE:latest .