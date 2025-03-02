#!/bin/bash

PACKAGE_TYPES=${PACKAGE_TYPES:="assemble bundle"}
APP_TYPES=${APP_TYPES:="embed"}
RECORD_TYPES=${RECORD_TYPES:="record noRecord"}
BUILD_TYPES=${BUILD_TYPES:="release"}

BUILD_TASKS=""
for PACKAGE in $PACKAGE_TYPES
do
    for APP in $APP_TYPES
    do
        for RECORD in $RECORD_TYPES
        do
            for BUILD in $BUILD_TYPES
            do
                BUILD_TASKS="${BUILD_TASKS} ${PACKAGE}${APP^}${RECORD^}${BUILD^}"
            done
        done
    done
done

APPLICATION_ID=${APPLICATION_ID:="org.love2d.android"}
GAME_TITLE=${GAME_TITLE:="LOVE for Android"}
VERSION_CODE=${VERSION_CODE:=1}
VERSION_NAME=${VERSION_NAME:="0.0.0"}
ICON=${ICON:="@drawable/love"}
GAME_DIR=${GAME_DIR:="/game"}

# package the apk with your own LÖVE game
if [ -d "$GAME_DIR" ]
then
    mkdir -p app/src/embed/assets
    cp -R "$GAME_DIR"/* app/src/embed/assets
fi

# give your package a unique name, change the version
sed -i -r \
  -e "s/applicationId .+/applicationId '$APPLICATION_ID'/" \
  -e "s/versionCode .+/versionCode $VERSION_CODE/" \
  -e "s/versionName .+/versionName '$VERSION_NAME'/" \
  app/build.gradle

# change the name
xmlstarlet ed -L \
  -u "/manifest/application/@android:label" -v "$GAME_TITLE" \
  -u "/manifest/application/activity/@android:label" -v "$GAME_TITLE" \
  app/src/main/AndroidManifest.xml

# change the icon
if [ -d "$ICONS_DIR" ]
then
    cp -R "$ICONS_DIR"/* app/src/main/res
fi
xmlstarlet ed -L \
  -u "/manifest/application/@android:icon" -v "$ICON" \
  app/src/main/AndroidManifest.xml

./gradlew $BUILD_TASKS

cd app/build
./sign-releases.sh
./package-debug-symbols.sh
cd ../..
