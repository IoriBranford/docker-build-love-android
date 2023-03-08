# Docker for Android SDK 31

Docker for Android SDK 31 with preinstalled build tools and emulator image

> Edit from [mindrunner/docker-android-sdk](https://github.com/mindrunner/docker-android-sdk)

**Installed Packages**
```bash
# sdkmanager --list
  Path                 | Version      | Description                             | Location            
  -------              | -------      | -------                                 | -------             
  build-tools;33.0.0   | 33.0.0       | Android SDK Build-Tools 33              | build-tools/33.0.0  
  cmdline-tools;latest | 9.0          | Android SDK Command-line Tools (latest) | cmdline-tools/latest
  ndk;23.2.8568313     | 23.2.8568313 | NDK (Side by side) 23.2.8568313         | ndk/23.2.8568313    
  patcher;v4           | 1            | SDK Patch Applier v4                    | patcher/v4          
  platform-tools       | 34.0.0       | Android SDK Platform-Tools              | platform-tools      
  platforms;android-33 | 2            | Android SDK Platform 33                 | platforms/android-33               
```

**Usage**

- Interactive way
  ```bash
  $ docker run -it --rm --device /dev/kvm androidsdk/android-31:latest bash
  # check installed packages
  $ sdkmanager --list
  # create and run emulator
  $ avdmanager create avd -n first_avd --abi google_apis/x86_64 -k "system-images;android-31;google_apis;x86_64"
  $ emulator -avd first_avd -no-window -no-audio &
  $ adb devices
  # You can also run other Android platform tools, which are all added to the PATH environment variable
  ```

  To connect the emulator using `adb` on the docker host machine, start the container with `--network host` as well.
  You could also use [`scrcpy`](https://github.com/Genymobile/scrcpy) to do a screencast of the emulator.

- Non-interactive way
  ```bash
  # check installed packages
  $ docker run -it --rm androidsdk/android-31:latest sdkmanager --list
  # list existing emulators
  $ docker run -it --rm androidsdk/android-31:latest avdmanager list avd
  # You can also run other Android platform tools, which are all added to the PATH environment variable
  ```