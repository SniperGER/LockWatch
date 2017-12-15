#if (TARGET_OS_SIMULATOR)
#define PREFERENCES_PATH @"/opt/simject/FESTIVAL/ml.festival.lockwatch.plist"
#define RESOURCES_PATH @"/opt/simject/FESTIVAL/LockWatch"
#else
#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/ml.festival.lockwatch.plist"
#define RESOURCES_PATH @"/var/mobile/Library/FESTIVAL/LockWatch"
#endif

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define deg2rad(angle) ((angle) / 180.0 * M_PI)
#define TESTING 1

#import "substrate.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <SpringBoard/SpringBoard.h>
#import <LockWatchKit/LockWatchKit.h>
#import "MTMaterialView.h"
#import "NCMaterialView.h"
#import "_UIBackdropView.h"

#import "Core/LWCore.h"
#import "Core/LWPluginManager.h"

#import "LockScreen/LWInterfaceView.h"
#import "LockScreen/LWScrollView.h"
#import "LockScreen/LWFaceLibraryOverlayView.h"
#import "LockScreen/LWFaceLibraryCustomizeButton.h"
