#!/bin/sh

export DOCKER_BUILDKIT=1

docker build . -f Dockerfile -t ioribranford/build-love-android:11.5-env
docker build . --pull=false -f Dockerfile-prebuilt -t ioribranford/build-love-android:11.5-full
docker build . --pull=false -f Dockerfile-action -t ioribranford/build-love-android:11.5-ghaction
