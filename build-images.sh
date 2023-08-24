#!/bin/sh

docker build . -f Dockerfile -t ioribranford/build-love-android:11.4-env
docker build . -f Dockerfile-prebuilt -t ioribranford/build-love-android:11.4-full
docker build . -f Dockerfile-action -t ioribranford/build-love-android:11.4-ghaction
