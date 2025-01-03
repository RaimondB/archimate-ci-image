#!/bin/bash

set -e

ARCHI_VERSION=5.4.3
COARCHI_VERSION=0.9.2

docker build \
  --tag "archimate-ci-image:$ARCHI_VERSION-dev" \
  --build-arg="ARCHI_VERSION=$ARCHI_VERSION" \
  --build-arg="COARCHI_VERSION=$COARCHI_VERSION" \
  ./

# docker build \
#   --file Dockerfile.rootless \
#   --tag "archimate-ci-image:$ARCHI_VERSION-dev-rootless" \
#   --build-arg="ARCHIMATE_CI_IMAGE=archimate-ci" \
#   --build-arg="ARCHIMATE_CI_VERSION=$ARCHI_VERSION-dev" \
#   ./