FROM alvrme/alpine-android:android-33-jdk17
RUN extras ndk --ndk 23.2.8568313

# to clone repo
RUN apk add --no-cache git

# to build
RUN apk add --no-cache file python3
RUN ln -s $(which python3) /usr/bin/python

# to zip debug symbols for the Play Store
RUN apk add --no-cache zip

# to edit AndroidManifest.xml
RUN apk add --no-cache xmlstarlet

CMD /bin/sh
