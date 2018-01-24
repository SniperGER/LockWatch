#import <UIKit/UIKit.h>

//! Project version number for LockWatchKit.
FOUNDATION_EXPORT double LockWatchKitVersionNumber;

//! Project version string for LockWatchKit.
FOUNDATION_EXPORT const unsigned char LockWatchKitVersionString[];

#define kCFCoreFoundationVersionNumber_iOS_10_2 1348.22
#define kCFCoreFoundationVersionNumber_iOS_10_3 1349.56
#define kCFCoreFoundationVersionNumber_iOS_11_0 1443.00
#define kCFCoreFoundationVersionNumber_iOS_11_1 1445.32
#define kCFCoreFoundationVersionNumber_iOS_11_2 1450.14
#define deg2rad(angle) ((angle) / 180.0 * M_PI)

#import <LockWatchKit/LWKActivityDataProvider.h>
#import <LockWatchKit/LWKWeatherDataProvider.h>
#import <LockWatchKit/LWKPageView.h>
#import <LockWatchKit/LWKClockHand.h>
#import <LockWatchKit/LWKClockBase.h>
#import <LockWatchKit/LWKAnalogClock.h>
#import <LockWatchKit/LWKDigitalClock.h>
#import <LockWatchKit/LWKFaceEditView.h>
#import <LockWatchKit/LWKScrollIndicator.h>
#import <LockWatchKit/LWKCustomizationDelegate.h>

#import "MTMaterialView.h"
#import "NCMaterialView.h"
#import "_UIBackdropView.h"
#import "Weather.h"
#import "WatchColors.h"
#import "WeatherIcons.h"
#import "UIFont+WDCustomLoader.h"
