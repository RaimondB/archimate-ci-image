#!/bin/bash

set -a
source .env
set +a

set -e

IMAGE_VERSION=0.10.0
ARCHI_VERSION=5.4.3
COARCHI_VERSION=0.9.2
USERNAME=$(whoami)

TARGET_BASE="$USERNAME/archimate-ci-image"
GHCR_TARGET_BASE="ghcr.io/$TARGET_BASE"

docker tag "$TARGET_BASE:dev" "$GHCR_TARGET_BASE:$IMAGE_VERSION"
docker tag "$TARGET_BASE:dev" "$GHCR_TARGET_BASE:latest"

echo $GH_PAT_DOCKER | docker login ghcr.io -u $USERNAME --password-stdin

docker push "$GHCR_TARGET_BASE:$IMAGE_VERSION"
docker push "$GHCR_TARGET_BASE:latest"



# docker build \
#   --file Dockerfile.rootless \
#   --tag "archimate-ci-image:$ARCHI_VERSION-dev-rootless" \
#   --build-arg="ARCHIMATE_CI_IMAGE=archimate-ci" \
#   --build-arg="ARCHIMATE_CI_VERSION=$ARCHI_VERSION-dev" \
#   ./