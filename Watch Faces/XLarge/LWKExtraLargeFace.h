#import <LockWatchKit/LockWatchKit.h>

@interface LWKExtraLargeFace : LWKDigitalClock {
	double cachedSecond;
	
	UILabel* hourLabel;
	UILabel* minuteLabel;
	UILabel* colonLabel;
}

@end
