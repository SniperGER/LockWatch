#import <LockWatchKit/LockWatchKit.h>
#import <HealthKit/HealthKit.h>
#import <HealthKitUI/HealthKitUI.h>

@interface HKActivityRingView (Private)

- (void)_setActivityRingViewBackgroundColor:(id)arg1;
- (void)_setActivityRingViewBackgroundTransparent:(BOOL)arg1;
- (void)_setRingDiameter:(CGFloat)arg1 ringInterspacing:(CGFloat)arg2 ringThickness:(CGFloat)arg3;

@end

@interface LWKActivityDigitalFace : LWKDigitalClock <LWKCustomizationDelegate> {
	double cachedSecond;
	
	NSDictionary* activityData;
	HKActivityRingView* activityRingView;
	
	UILabel* secondsLabel1;
	UILabel* secondsLabel2;
	UILabel* colonLabel;
	
	UIView* dateContainer;
	
	UILabel* activeEnergy;
	UILabel* brisk;
	UILabel* movingHours;
}

@end
