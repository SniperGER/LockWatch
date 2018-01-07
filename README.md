#  LockWatch

Display watch faces on your iOS Lock Screen – inspired by Apple Watch

## Description

LockWatch is back (again) – this time even for unjailbroken users!

LockWatch brings an almost perfect recreation of most of the watch faces included in watchOS 4 – right to your iOS LockScreen.
For jailbroken users, the tweak just works as it did before, but for unjailbroken users, I created the LockWatch Demo app, so that they can experience this attention to detail too. It won't work on the lockscreen though.

Both the tweak and the demo app are compatible with iOS 10 and iOS 11 on both iPhone and iPad, with iOS 9 support following early 2018.

## Usage

LockWatch works just like Apple Watch: Force touch a watch face to enter selection mode, swipe through all available watch faces and select the one you like, or customize it the way you want. On devices that do not feature 3D Touch, you can long press to enter selection mode.

When using the tweak, press the home button to leave selection or editing mode. The demo app provides a button to emulate the home button in these cases.

To install the demo app on an unjailbroken device, head over to the Releases section, download the latest .ipa and use Cydia Impactor to install the app to your device. You can also sign it with a provisioning profile from Apple's 99$ Developer Program using iOS App Signer and install it using Xcode.

## Included Watch Faces

* Activity Analog
* Activity Digital
* Numerals (currently only with "Regular" style)
* Utility
* Simple
* Color
* Chronograph
* X-Large

A Weather watch face is also planned.
Most of the watch faces can also be colored in one of the 40 colors supported in watchOS 4.

## Building this project

Building this project requires at least Xcode 8 and my developer headers, which will be released in the coming days.

To build the tweak part of LockWatch, you'll also need [Theos](https://github.com/theos/theos), the [iOS 10.1 SDK including private frameworks](https://github.com/theos/sdks), [Cephei](https://github.com/hbang/libcephei) and, if you're building for the Simulator, [simject](https://github.com/angelXwind/simject).

Inside the Xcode project, there are multiple schemes to build with. "Build" compiles LockWatch as a tweak, "Install" compiles it and installs it directly to your device, "Build (Simulator)" builds it for the iOS Simulator and resprings it and "LockWatch Demo" to build the demo app.

To install LockWatch directly to your device from Xcode, you'll need a passwordless SSH connection to your device. To do this, have a look [here](https://help.ubuntu.com/community/iphone%20passwordless%20access). Running the tweak inside the Simulator also requires a few symlinks:

```
# Create a symlink for LockWatchKit.framework inside the iOS SDK
# Replace $(LOCKWATCH_PROJECT_DIR) with your download directory

# If you're using the Simulator runtime included in Xcode
cd /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks

# If you're using any downloaded Simulator runtime (in this case 10.2)
cd /Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 10.2.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks

ln -s $(LOCK_WATCH_PROJECT_DIR)/LockWatch/Layout/var/mobile/Library/FESTIVAL/LockWatch/LockWatchKit.framework

# Create a symlink inside the simject folder
mkdir -p /opt/simject/FESTIVAL
cd /opt/simject/FESTIVAL
ln -s $(LOCK_WATCH_PROJECT_DIR)/LockWatch/Layout/var/mobile/Library/FESTIVAL/LockWatch

```

If you want to build the demo app instead, make sure to set `APP_CONTEXT` to 1 in `LockWatch.h`

If there is any issue when building LockWatch, feel free to open an issue here.

## Creating Watch Faces

TODO

## Special Thanks

* Anthony Bouchard for his great [article on iDownloadBlog](http://www.idownloadblog.com/2017/12/06/lockwatch/) motivating me to work on LockWatch again
