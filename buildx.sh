#!/bin/bash

set -x

export DOCKER_CLI_EXPERIMENTAL=enabled
podman run --rm --privileged tonistiigi/binfmt:latest --install all
podman buildx version
# podman buildx create --use --name=multipleplatforms --driver docker-container
# podman buildx ls

set +x

IMAGE_NAME=$2
DOCKERFILE_PATH=$1
if [ ! "$DOCKERFILE_PATH" == "" ] && [ ! "$IMAGE_NAME" == "" ]; then
podman buildx build --push --platform linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6 -f $DOCKERFILE_PATH -t $IMAGE_NAME .
else
echo "nothing to do"
fi
