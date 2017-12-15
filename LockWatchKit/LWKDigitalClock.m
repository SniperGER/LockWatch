#import "LWKDigitalClock.h"

@implementation LWKDigitalClock

- (void)didStopUpdatingTime {
	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

@end
