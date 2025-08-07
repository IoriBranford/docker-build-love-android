FROM alvrme/alpine-android:android-36-jdk17

# versions specified in love-android/app/build.gradle
RUN extras ndk --ndk 27.3.13750724
RUN sdkmanager --install "build-tools;35.0.0"

# to clone repo
RUN apk add --no-cache git

# to build
RUN apk add --no-cache file grep

# to zip debug symbols for the Play Store
RUN apk add --no-cache zip

# to edit AndroidManifest.xml
RUN apk add --no-cache xmlstarlet

CMD /bin/sh
