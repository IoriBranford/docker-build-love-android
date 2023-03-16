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
    echo "apks$TYPE=/love-android/app/build/outputs/apk/embed$TYPE/release/" >> $GITHUB_OUTPUT
    echo "bundles$TYPE=/love-android/app/build/outputs/bundle/embed${TYPE}Release/" >> $GITHUB_OUTPUT
done
