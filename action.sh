#!/bin/sh -l

export GAME_DIR=${GAME_DIR:=$GITHUB_WORKSPACE}

cd /love-android
./build.sh

for TYPE in NoRecord Record
do
    echo "apk$TYPE=/love-android/app/build/outputs/apk/embed$TYPE/release/embed$TYPE-release-signed.apk" >> $GITHUB_OUTPUT
    echo "bundle$TYPE=/love-android/app/build/outputs/bundle/embed${TYPE}Release/embed${TYPE}Release-signed.aab" >> $GITHUB_OUTPUT
done
