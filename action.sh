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
    echo "apk$TYPE=/love-android/app/build/outputs/apk/embed$TYPE/release/embed$TYPE-release-signed.apk" >> $GITHUB_OUTPUT
    echo "bundle$TYPE=/love-android/app/build/outputs/bundle/embed${TYPE}Release/embed${TYPE}Release-signed.aab" >> $GITHUB_OUTPUT
done
