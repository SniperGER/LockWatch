#import "LWKClockHand.h"

@implementation LWKClockHand

+ (id)hour {
	LWKClockHand* hourHand = [[LWKClockHand alloc] initWithImage:[[UIImage imageNamed:@"hour" inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[hourHand setTintColor:[UIColor whiteColor]];
	[hourHand.layer setAnchorPoint:CGPointMake(0.5, 167.0/182.0)];
	
	return hourHand;
}

+ (id)minute {
	LWKClockHand* minuteHand = [[LWKClockHand alloc] initWithImage:[[UIImage imageNamed:@"minute" inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[minuteHand setTintColor:[UIColor whiteColor]];
	[minuteHand.layer setAnchorPoint:CGPointMake(0.5, 287.0/302.0)];
	
	return minuteHand;
}

+ (id)second {
	LWKClockHand* secondHand = [[LWKClockHand alloc] initWithImage:[[UIImage imageNamed:@"second" inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[secondHand setTintColor:[UIColor colorWithRed:1.0 green:0.584 blue:0.0 alpha:1.0]];
	[secondHand.layer setAnchorPoint:CGPointMake(0.5, 311.0/362.0)];
	
	return secondHand;
}

@end
