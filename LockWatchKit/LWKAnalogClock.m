#import "LockWatchKit.h"
#import "LWKCustomizationSelector.h"

@implementation LWKAnalogClock

- (id)init {
	if (self = [super init]) {
		hourHand = [LWKClockHand hour];
		[hourHand.layer setPosition:CGPointMake(156, 195)];
		[self.contentView addSubview:hourHand];
		
		minuteHand = [LWKClockHand minute];
		[minuteHand.layer setPosition:CGPointMake(156, 195)];
		[self.contentView addSubview:minuteHand];
		
		secondHand = [LWKClockHand second];
		[secondHand.layer setPosition:CGPointMake(156, 195)];
		[self.contentView addSubview:secondHand];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	hour = (hour >= 12) ? hour - 12 : hour;
	[super updateForHour:hour minute:minute second:second millisecond:msecond animated:animated];
	
	CGFloat secondValue = second / 60.0 + ((msecond / 1000.0) / 60.0);
	CGFloat minuteValue = (minute / 60.0) + (secondValue / 60.0);
	CGFloat hourValue = (hour / 12.0) + (minuteValue / 12.0);
	
	if (secondHand) {
		[secondHand.layer removeAllAnimations];
		[secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* secondAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[secondAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[secondAnim setDuration:60.0];
			[secondAnim setCumulative:YES];
			[secondAnim setRepeatCount:HUGE_VALF];
			
			[secondHand.layer addAnimation:secondAnim forKey:@"secondRotation"];
		}
	}
	
	if (minuteHand) {
		[minuteHand.layer removeAllAnimations];
		[minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* minuteAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[minuteAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[minuteAnim setDuration:60 * 60];
			[minuteAnim setCumulative:YES];
			[minuteAnim setRepeatCount:HUGE_VALF];
			
			[minuteHand.layer addAnimation:minuteAnim forKey:@"minuteRotation"];
		}
	}
	
	if (hourHand) {
		[(hourHand).layer removeAllAnimations];
		[(hourHand) setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* hourAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[hourAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[hourAnim setDuration:60.0 * 60.0 * 12.0];
			[hourAnim setCumulative:YES];
			[hourAnim setRepeatCount:HUGE_VALF];
			
			[(hourHand).layer addAnimation:hourAnim forKey:@"hourRotation"];
		}
	}
}

- (void)didStartUpdatingTime {
	if (secondHand) {
		[secondHand.layer removeAllAnimations];
	}
	if (minuteHand) {
		[minuteHand.layer removeAllAnimations];
	}
	if (hourHand) {
		[hourHand.layer removeAllAnimations];
	}
	
	NSDate* date = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents *minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents *secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents *MsecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float Hour = ([hourComp hour] >= 12) ? [hourComp hour] - 12 : [hourComp hour];
	float Minute = [minuteComp minute];
	float Second = [secondComp second];
	float Msecond = roundf([MsecondComp nanosecond]/1000000);
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration:0.25 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (secondHand) {
			[secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (minuteHand) {
			[minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (hourHand) {
			[hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:^(BOOL finished) {
		
	}];
}

- (void)didStopUpdatingTime {
	if (secondHand) {
		[secondHand.layer removeAllAnimations];
	}
	if (minuteHand) {
		[minuteHand.layer removeAllAnimations];
	}
	if (hourHand) {
		[hourHand.layer removeAllAnimations];
	}
	
	float Hour = 10.0;
	float Minute = 9.0;
	float Second = 30.0;
	float Msecond = 0.0;
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration:0.25 delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (secondHand) {
			[secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (minuteHand) {
			[minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (hourHand) {
			[hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:nil];
}

#pragma mark Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	if (isEditing) {
		if ([currentCustomizationSelector isKindOfClass:NSClassFromString(@"LWKStyleCustomizationSelector")]) {
			[hourHand setAlpha:0.0];
			[minuteHand setAlpha:0.0];
			[secondHand setAlpha:0.0];
		} else if ([currentCustomizationSelector isKindOfClass:NSClassFromString(@"LWKColorCustomizationSelector")]) {
			// TODO
		} else {
			[hourHand setAlpha:1.0];
			[minuteHand setAlpha:1.0];
			[secondHand setAlpha:1.0];
		}
															 
	} else {
		[hourHand setAlpha:1.0];
		[minuteHand setAlpha:1.0];
		[secondHand setAlpha:1.0];
	}
}

// Accent Color
- (void)setAccentColor:(UIColor *)color {
	[secondHand setTintColor:color];
}

@end
