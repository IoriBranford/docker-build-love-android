#!/bin/bash

if [ -f "$ENV_SCRIPT" ]
then
    . "$ENV_SCRIPT"
fi

if [ ! -d "$GAME_DIR" ]
then
    export GAME_DIR=$GITHUB_WORKSPACE
fi

cd /love-android
./build-game.sh

RECORD_TYPES=${RECORD_TYPES:="record noRecord"}

for RECORD in $RECORD_TYPES
do
    APK_DIR=/love-android/app/build/outputs/apk/embed${RECORD^}/release/
    if [ -d $APK_DIR ]
    then
        cp -r $APK_DIR $GITHUB_WORKSPACE/apks${RECORD^}
        echo "apks${RECORD^}=apks${RECORD^}/" >> $GITHUB_OUTPUT
    fi
    BUNDLE_DIR=/love-android/app/build/outputs/bundle/embed${RECORD^}Release/
    if [ -d $BUNDLE_DIR ]
    then
        cp -r $BUNDLE_DIR $GITHUB_WORKSPACE/bundles${RECORD^}
        echo "bundles${RECORD^}=bundles${RECORD^}/" >> $GITHUB_OUTPUT
    fi
done
