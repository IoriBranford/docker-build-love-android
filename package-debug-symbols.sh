#!/bin/sh

for DIR in outputs/bundle/*
do
    BUILD_TYPE=`basename $DIR`
    DEBUG_SYMBOLS_PATH=intermediates/merged_native_libs/$BUILD_TYPE/out/lib/
    cp -r $DEBUG_SYMBOLS_PATH/* .
    zip -r outputs/bundle/$BUILD_TYPE/native-debug-symbols.zip `ls $DEBUG_SYMBOLS_PATH`
    rm -rf `ls $DEBUG_SYMBOLS_PATH`
done
