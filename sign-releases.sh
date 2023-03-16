#!/bin/sh

if [ -z "$KEYSTORE_FILE" ] || [ -z "$KEYSTORE_ALIAS" ] || [ -z "$KEYSTORE_PASSWORD" ]
then
    echo "Not signing. Missing vars: KEYSTORE_FILE, KEYSTORE_ALIAS, and KEYSTORE_PASSwORD"
    exit 1
fi

for DIR in outputs/apk/*
do
    BUILD_TYPE=`basename $DIR`
    UNSIGNED_APK=`find $DIR/release -name "*-unsigned.apk"
    if [ ! -z "$UNSIGNED_APK" ]
    then
        apksigner sign --ks "$KEYSTORE_FILE" \
            --ks-key-alias $KEYSTORE_ALIAS \
            --ks-pass env:KEYSTORE_PASSWORD --key-pass env:KEYSTORE_PASSWORD \
            --out $DIR/release/$BUILD_TYPE-release-signed.apk \
            $UNSIGNED_APK
    fi
done

for DIR in outputs/bundle/*Release
do
    BUILD_TYPE=`basename $DIR`
    UNSIGNED_BUNDLE=`find $DIR -name "*.aab"
    if [ ! -z "$UNSIGNED_BUNDLE" ]
    then
        jarsigner -keystore "$KEYSTORE_FILE" \
            -storepass $KEYSTORE_PASSWORD \
            -signedjar $DIR/$BUILD_TYPE-signed.aab \
            $UNSIGNED_BUNDLE \
            $KEYSTORE_ALIAS
    fi
done
