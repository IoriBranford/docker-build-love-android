# build-love-android
CI build environments for the Android version of LOVE. The tag indicates what version can be built and what is included.

## Examples with `env`

An `env` tag only provides the build environment.

### Building in shell
```bash
export LOVE_VER=11.4

git clone --recursive -b $LOVE_VER https://github.com/love2d/love-android
cd love-android
docker run -i -t --rm \
	-v $(pwd):$(pwd) -w $(pwd) --user $(id -u):$(id -g) \
	ioribranford/build-love-android:$LOVE_VER-env \
	./gradlew assembleNormalRecord
```

### Building in GitLab CI
```yaml
build-android:
        stage: build
        image: ioribranford/build-love-android:11.4-env
        script:
                - git clone --recursive -b "11.4" https://github.com/love2d/love-android
                - cd love-android
                - ./gradlew assembleNormalRecord bundleNormalRecord
        artifacts:
                name: "${CI_PROJECT_NAME}-${CI_COMMIT_REF_NAME}-android"
                paths:
                        - "app/build/outputs/apk"
                        - "app/build/outputs/bundle"
```

### Editing AndroidManifest
xmlstarlet is included.
```bash
export GAME_TITLE="My Lovely Game"

xmlstarlet ed -L \
  -u "/manifest/application/@android:label" -v "$GAME_TITLE" \
  -u "/manifest/application/activity/@android:label" -v "$GAME_TITLE" \
  app/src/main/AndroidManifest.xml
```

### Full example
Following instructions from love-android wiki https://github.com/love2d/love-android/wiki/Game-Packaging
```bash
export LOVE_VER=11.4
export GAME_DIR="./game"
export GAME_ID=com.example.mygame
export VERSION_CODE=1
export VERSION_NAME=1.0
export GAME_TITLE="My Lovely Game"
export ICON_DIR="./androidicons"
export ICON_ID="@mipmap/ic_launcher"
export KEYSTORE="keystore.jks"
# define secret KEYSTORE_ALIAS and KEYSTORE_PASSWORD elsewhere

git clone --recursive -b $LOVE_VER https://github.com/love2d/love-android
cd love-android

# package the apk with your own LÖVE game
mkdir -p app/src/embed/assets
cp -R "$GAME_PATH"/* app/src/embed/assets

# give your package a unique name, change the version
sed -i -r \
  -e "s/applicationId .+/applicationId '$GAME_ID'/" \
  -e "s/versionCode .+/versionCode $VERSION_CODE/" \
  -e "s/versionName .+/versionName '$VERSION_NAME'/" \
  app/build.gradle

# change the name
xmlstarlet ed -L \
  -u "/manifest/application/@android:label" -v "$GAME_TITLE" \
  -u "/manifest/application/activity/@android:label" -v "$GAME_TITLE" \
  app/src/main/AndroidManifest.xml

# change the icon
cp -R $ICONS_DIR/* app/src/main/res
xmlstarlet ed -L \
  -u "/manifest/application/@android:icon" -v "$ICON_ID" \
  app/src/main/AndroidManifest.xml

# build
./gradlew assembleEmbedRecordRelease bundleEmbedRecordRelease

# sign apk and bundle if release
apksigner sign --ks "$KEYSTORE" \
  --ks-key-alias $KEYSTORE_ALIAS \
  --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEYSTORE_PASSWORD \
  --out "${GAME_TITLE}.apk" \
  app/build/outputs/apk/embedRecord/release/app-embed-record-release-unsigned.apk
jarsigner -keystore "$KEYSTORE" \
  -storepass $KEYSTORE_PASSWORD \
  -signedjar "${GAME_TITLE}.aab" \
  app/build/outputs/bundle/embedRecordRelease/app-embed-record-release.aab \
  $KEYSTORE_ALIAS

# make debug symbols package
DEBUG_SYMBOLS_PATH=app/build/intermediates/merged_native_libs/embedRecordRelease/out/lib/
cp -r $DEBUG_SYMBOLS_PATH/* .
zip -r native-debug-symbols.zip $(ls $DEBUG_SYMBOLS_PATH)
```

## Examples with `full`

A `full` tag includes a prebuilt love-android to eliminate initial compilation time. Its default action is to customize the app according to env vars and then build.

For these examples, assume a script `buildenv.sh`:

```bash
export LOVE_VER=11.4
export GAME_DIR="$PWD/game"
export APPLICATION_ID=com.example.mygame
export VERSION_CODE=1
export VERSION_NAME=1.0
export GAME_TITLE="My Lovely Game"
export ICONS_DIR="$PWD/androidicons"
export ICON="@mipmap/ic_launcher"
export KEYSTORE_FILE="$PWD/keystore.jks"
```

### Build in shell

```bash
. ./buildenv.sh
export KEYSTORE_ALIAS=KeystoreAlias
export KEYSTORE_PASSWORD=K3yst0rePa55w0rd

docker run --rm \
	-v $GAME_DIR:/game:ro \
	-v ./outputs:/love-android/app/build/outputs \
	-e KEYSTORE_FILE \
	-e KEYSTORE_ALIAS -e KEYSTORE_PASSWORD \
	-e APPLICATION_ID \
	-e GAME_TITLE \
	-e VERSION_NAME \
	-e VERSION_CODE \
	-e ICON \
	-v $ICONS_DIR:/love-android/app/src/main/res:ro \
	ioribranford/build-love-android:$LOVE_VER-full
```

### Build in a GitHub workflow
```yaml
on: [workflow_dispatch]

jobs:
  build-android:
    runs-on: ubuntu-latest
    name: Build for Android
    steps:
      - uses: actions/checkout@v3
      - id: build
        uses: ioribranford/docker-build-love-android@11.4
        env:
          ENV_SCRIPT: "buildenv.sh"
          KEYSTORE_ALIAS: ${{ secrets.KEYSTORE_ALIAS }}
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
      - uses: actions/upload-artifact@v3
        with:
          name: android-builds
          path: |
            ${{ steps.build.outputs.apkNoRecord }}
            ${{ steps.build.outputs.apkRecord }}
            ${{ steps.build.outputs.bundleNoRecord }}
            ${{ steps.build.outputs.bundleRecord }}
```