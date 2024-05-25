FROM alvrme/alpine-android:android-34-jdk17

# versions specified in love-android/app/build.gradle
RUN extras ndk --ndk 25.2.9519653
RUN sdkmanager --install "build-tools;34.0.0"

# to clone repo
RUN apk add --no-cache git

# to build
RUN apk add --no-cache file python3

# to zip debug symbols for the Play Store
RUN apk add --no-cache zip

# to edit AndroidManifest.xml
RUN apk add --no-cache xmlstarlet

CMD /bin/sh
