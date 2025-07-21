#!/bin/sh

BUILD_TASKS=${BUILD_TASKS:="assembleEmbedRecordRelease bundleEmbedRecordRelease assembleEmbedNoRecordRelease bundleEmbedNoRecordRelease"}

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

# give your package a unique name, change the version, change the name
sed -i -r \
  -e "s/^#(app.name)=.+/\\1=$GAME_TITLE/" \
  -e "s/^app.name_byte_array/#&/" \
  -e "s/^(app.application_id)=.+/\\1=$APPLICATION_ID/" \
  -e "s/^(app.version_code)=.+/\\1=$VERSION_CODE/" \
  -e "s/^(app.version_name)=.+/\\1=$VERSION_NAME/" \
  gradle.properties

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
