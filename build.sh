#!/bin/sh

BUILD_TASKS=${BUILD_TASKS:="assembleEmbedRecordRelease bundleEmbedRecordRelease assembleEmbedNoRecordRelease bundleEmbedNoRecordRelease"}

ID=${ID:="org.love2d.android"}
TITLE=${TITLE:="LOVE for Android"}
VERSIONCODE=${VERSIONCODE:=1}
VERSIONNAME=${VERSIONNAME:="0.0.0"}
ICON=${ICON:="@drawable/love"}

# package the apk with your own LÖVE game
if [ ! -z "$GAME_FILES" ]
then
    mkdir -p app/src/embed/assets
    cp -R $GAME_FILES app/src/embed/assets
fi

# give your package a unique name, change the version
sed -i -r \
  -e "s/applicationId .+/applicationId '$ID'/" \
  -e "s/versionCode .+/versionCode $VERSIONCODE/" \
  -e "s/versionName .+/versionName '$VERSIONNAME'/" \
  app/build.gradle

# change the name
xmlstarlet ed -L \
  -u "/manifest/application/@android:label" -v "$TITLE" \
  -u "/manifest/application/activity/@android:label" -v "$TITLE" \
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
