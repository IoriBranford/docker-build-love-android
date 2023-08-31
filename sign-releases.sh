#!/bin/sh

if [ -z "$KEYSTORE_FILE" ] || [ -z "$KEYSTORE_ALIAS" ] || [ -z "$KEYSTORE_PASSWORD" ]
then
    echo "Not signing. Missing vars: KEYSTORE_FILE, KEYSTORE_ALIAS, and KEYSTORE_PASSwORD"
    exit 1
fi

APP_TYPES=${APP_TYPES:="embed"}
RECORD_TYPES=${RECORD_TYPES:="record noRecord"}

for APP in $APP_TYPES
do
    for RECORD in $RECORD_TYPES
    do
        OUTPUT_NAME="app-${APP}-${RECORD}-release"

        UNSIGNED_APK=`find outputs/apk -name "$OUTPUT_NAME-unsigned.apk"`
        if [ ! -z "$UNSIGNED_APK" ]
        then
            APK_DIR=`dirname $UNSIGNED_APK`
            apksigner sign --ks "$KEYSTORE_FILE" \
                --ks-key-alias $KEYSTORE_ALIAS \
                --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEYSTORE_PASSWORD \
                --out $APK_DIR/$OUTPUT_NAME-signed.apk \
                $UNSIGNED_APK
        fi

        UNSIGNED_BUNDLE=`find outputs/bundle -name "$OUTPUT_NAME.aab"`
        if [ ! -z "$UNSIGNED_BUNDLE" ]
        then
            BUNDLE_DIR=`dirname $UNSIGNED_BUNDLE`
            jarsigner -keystore "$KEYSTORE_FILE" \
                -storepass $KEYSTORE_PASSWORD \
                -signedjar $BUNDLE_DIR/$OUTPUT_NAME-signed.aab \
                $UNSIGNED_BUNDLE \
                $KEYSTORE_ALIAS
        fi
    done
done
