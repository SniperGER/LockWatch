#import <LockWatchKit/LockWatchKit.h>
#import <HealthKit/HealthKit.h>
#import <HealthKitUI/HealthKitUI.h>

@interface HKActivityRingView (Private)

- (void)_setActivityRingViewBackgroundColor:(id)arg1;
- (void)_setActivityRingViewBackgroundTransparent:(BOOL)arg1;
- (void)_setRingDiameter:(CGFloat)arg1 ringInterspacing:(CGFloat)arg2 ringThickness:(CGFloat)arg3;

@end


@interface HKRingGroupController : NSObject

- (void)setRingDiameter:(CGFloat)arg1;
- (void)setRingThickness:(CGFloat)arg1;
- (void)setCenter:(CGPoint)arg1;

@end


@interface HKRingsView : UIView

+ (id)ringsViewConfiguredForOneRingOnWatchOfType:(int)arg1 withIcon:(BOOL)arg2;
- (NSArray<HKRingGroupController*>*)ringGroups;
- (void)_setupIfNeccessary;
- (void)setActiveEnergyPercentage:(CGFloat)arg1 animated:(BOOL)arg2;
- (void)setBriskPercentage:(CGFloat)arg1 animated:(BOOL)arg2;
- (void)setMovingHoursPercentage:(CGFloat)arg1 animated:(BOOL)arg2;

@end


@interface LWKActivityAnalogFace : LWKAnalogClock {
	UIView* dial;
	UIView* mainView;
	
	UIView* secondaryView;
	UILabel* activeEnergy;
	UILabel* brisk;
	UILabel* movingHours;
	HKRingsView* activeEnergyRing;
	HKRingsView* briskRing;
	HKRingsView* movingHoursRing;
	
	HKActivityRingView* activityRingView;
	
	NSDictionary* activityData;
}

@end
