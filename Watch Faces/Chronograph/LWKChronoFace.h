#import <LockWatchKit/LockWatchKit.h>

@interface LWKChronoFace : LWKAnalogClock {
	_UIBackdropView* backgroundView;
	
	int dateLabelDetail;
	UIImageView* indicatorImage;
	UIImageView* chronoStopwatchSeconds;
	UIImageView* chronoStopwatchMinutes;
}

@end
