#import "LockWatchKit.h"
#import "LWKCustomizationSelector.h"

@implementation LWKAnalogClock

- (id)init {
	if (self = [super init]) {
		_hourHand = [LWKClockHand hour];
		[_hourHand.layer setPosition:CGPointMake(156, 156)];
		[self.indicatorView addSubview:_hourHand];
		
		_minuteHand = [LWKClockHand minute];
		[_minuteHand.layer setPosition:CGPointMake(156, 156)];
		[self.indicatorView addSubview:_minuteHand];
		
		_secondHand = [LWKClockHand second];
		[_secondHand.layer setPosition:CGPointMake(156, 156)];
		[self.indicatorView addSubview:_secondHand];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	hour = (hour >= 12) ? hour - 12 : hour;
	[super updateForHour:hour minute:minute second:second millisecond:msecond animated:animated];
	
	CGFloat secondValue = second / 60.0 + ((msecond / 1000.0) / 60.0);
	CGFloat minuteValue = (minute / 60.0) + (secondValue / 60.0);
	CGFloat hourValue = (hour / 12.0) + (minuteValue / 12.0);
	
	if (_secondHand) {
		[_secondHand.layer removeAllAnimations];
		[_secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* secondAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[secondAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[secondAnim setDuration:60.0];
			[secondAnim setCumulative:YES];
			[secondAnim setRepeatCount:HUGE_VALF];
			
			[_secondHand.layer addAnimation:secondAnim forKey:@"secondRotation"];
		}
	}
	
	if (_minuteHand) {
		[_minuteHand.layer removeAllAnimations];
		[_minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* minuteAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[minuteAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[minuteAnim setDuration:60 * 60];
			[minuteAnim setCumulative:YES];
			[minuteAnim setRepeatCount:HUGE_VALF];
			
			[_minuteHand.layer addAnimation:minuteAnim forKey:@"minuteRotation"];
		}
	}
	
	if (_hourHand) {
		[(_hourHand).layer removeAllAnimations];
		[(_hourHand) setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue * 360.0))];
		
		if (animated) {
			CABasicAnimation* hourAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			[hourAnim setByValue:[NSNumber numberWithFloat:M_PI * 2.0]];
			[hourAnim setDuration:60.0 * 60.0 * 12.0];
			[hourAnim setCumulative:YES];
			[hourAnim setRepeatCount:HUGE_VALF];
			
			[(_hourHand).layer addAnimation:hourAnim forKey:@"hourRotation"];
		}
	}
}

- (void)didStartUpdatingTime {
	if (_secondHand) {
		[_secondHand.layer removeAllAnimations];
	}
	if (_minuteHand) {
		[_minuteHand.layer removeAllAnimations];
	}
	if (_hourHand) {
		[_hourHand.layer removeAllAnimations];
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
		if (_secondHand) {
			[_secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (_minuteHand) {
			[_minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (_hourHand) {
			[_hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:^(BOOL finished) {
		
	}];
}

- (void)didStopUpdatingTime {
	if (_secondHand) {
		[_secondHand.layer removeAllAnimations];
	}
	if (_minuteHand) {
		[_minuteHand.layer removeAllAnimations];
	}
	if (_hourHand) {
		[_hourHand.layer removeAllAnimations];
	}
	
	float Hour = 10.0;
	float Minute = 9.0;
	float Second = 30.0;
	float Msecond = 0.0;
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration:0.25 delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (_secondHand) {
			[_secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (_minuteHand) {
			[_minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (_hourHand) {
			[_hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:nil];
}

#pragma mark Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[_secondHand setTintColor:[[WatchColors colors] objectForKey:color]];
	[super setAccentColor:color];
}

@end
