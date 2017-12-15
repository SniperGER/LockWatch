#import "LWKClockBase.h"
#import "LWKClockHand.h"

@interface LWKAnalogClock : LWKClockBase {
	LWKClockHand* hourHand;
	LWKClockHand* minuteHand;
	LWKClockHand* secondHand;
}

@end
