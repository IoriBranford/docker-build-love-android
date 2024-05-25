#!/bin/sh

docker build . -f Dockerfile -t ioribranford/build-love-android:11.5-env
docker build . -f Dockerfile-prebuilt -t ioribranford/build-love-android:11.5-full
docker build . -f Dockerfile-action -t ioribranford/build-love-android:11.5-ghaction
