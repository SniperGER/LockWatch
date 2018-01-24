#import "LWKClockBase.h"
#import "LWKClockHand.h"

@interface LWKAnalogClock : LWKClockBase

@property (nonatomic, strong) LWKClockHand* hourHand;
@property (nonatomic, strong) LWKClockHand* minuteHand;
@property (nonatomic, strong) LWKClockHand* secondHand;

@end
