FROM alvrme/alpine-android:android-35-jdk17

# versions specified in love-android/app/build.gradle
RUN extras ndk --ndk 27.1.12297006
RUN sdkmanager --install "build-tools;35.0.0"

# to clone repo
RUN apk add --no-cache git

# to build
RUN apk add --no-cache file python3

# to zip debug symbols for the Play Store
RUN apk add --no-cache zip

# to edit AndroidManifest.xml
RUN apk add --no-cache xmlstarlet

CMD /bin/sh
