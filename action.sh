#!/bin/sh -l

if [ -f "$ENV_SCRIPT" ]
then
    . "$ENV_SCRIPT"
fi

if [ ! -d "$GAME_DIR" ]
then
    export GAME_DIR=$GITHUB_WORKSPACE
fi

cd /love-android
./build.sh

for TYPE in NoRecord Record
do
    cp /love-android/app/build/outputs/apk/embed$TYPE/release/ $GITHUB_WORKSPACE/apks$TYPE
    cp /love-android/app/build/outputs/bundle/embed${TYPE}Release/ $GITHUB_WORKSPACE/bundles$TYPE
    echo "apks$TYPE=apks$TYPE/" >> $GITHUB_OUTPUT
    echo "bundles$TYPE=bundles$TYPE/" >> $GITHUB_OUTPUT
done
