#!/bin/bash

set -a
source .env
set +a

set -e

IMAGE_VERSION=0.11.0
ARCHI_VERSION=5.4.3
COARCHI_VERSION=0.9.2
USERNAME=$(whoami)

TARGET_BASE="$USERNAME/archimate-ci-image"
CR_TARGET_BASE="$TARGET_BASE"

docker tag "$TARGET_BASE:dev" "$CR_TARGET_BASE:$IMAGE_VERSION"
docker tag "$TARGET_BASE:dev" "$CR_TARGET_BASE:latest"

echo $DH_PAT | docker login docker.io -u $USERNAME --password-stdin

docker push "$CR_TARGET_BASE:$IMAGE_VERSION"
docker push "$CR_TARGET_BASE:latest"



# docker build \
#   --file Dockerfile.rootless \
#   --tag "archimate-ci-image:$ARCHI_VERSION-dev-rootless" \
#   --build-arg="ARCHIMATE_CI_IMAGE=archimate-ci" \
#   --build-arg="ARCHIMATE_CI_VERSION=$ARCHI_VERSION-dev" \
#   ./