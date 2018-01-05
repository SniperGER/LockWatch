#import <LockWatchKit/LockWatchKit.h>

@interface LWKChronoFace : LWKAnalogClock {
	int dateLabelDetail;
	UIImageView* indicatorImage;
	UIImageView* chronoStopwatchSeconds;
	UIImageView* chronoStopwatchMinutes;
}

@end
