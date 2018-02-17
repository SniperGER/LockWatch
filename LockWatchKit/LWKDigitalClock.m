#import "LWKDigitalClock.h"

@implementation LWKDigitalClock

- (void)didStopUpdatingTime:(BOOL)animated {
	[self updateForHour:10 minute:9 second:30 millisecond:0 startAnimation:NO];
}

@end
