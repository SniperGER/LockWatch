#import "LWKActivityDigitalFace.h"

@implementation LWKActivityDigitalFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 390) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setCornerRadius:10];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, 312, 96)];
		[clockLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[clockLabel setTextAlignment:NSTextAlignmentRight];
		[clockLabel setText:@"10:09:30"];
		[self.contentView addSubview:clockLabel];
		
		secondsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(312-90, 56, 45, 96)];
		[secondsLabel1 setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[secondsLabel1 setTextAlignment:NSTextAlignmentCenter];
		[self.contentView addSubview:secondsLabel1];
		
		secondsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(312-47, 56, 45, 96)];
		[secondsLabel2 setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[secondsLabel2 setTextAlignment:NSTextAlignmentCenter];
		[self.contentView addSubview:secondsLabel2];
		
		colonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, 312, 96)];
		[colonLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[colonLabel setTextColor:[UIColor clearColor]];
		[colonLabel setTextAlignment:NSTextAlignmentRight];
		[colonLabel setText:@"10:09:30"];
		[self.contentView addSubview:colonLabel];
		
		dateContainer = [[UIView alloc] initWithFrame:CGRectMake(246, 2, 64, 64)];
		[dateContainer setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1.0]];
		[dateContainer.layer setCornerRadius:32.0];
		[self.contentView addSubview:dateContainer];
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
		[self.dateLabel setTextAlignment:NSTextAlignmentCenter];
		[self.dateLabel setTextColor:[UIColor whiteColor]];
		[self.dateLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Regular" size:34]];
		[dateContainer addSubview:self.dateLabel];
		
		activityRingView = [[HKActivityRingView alloc] initWithFrame:CGRectMake(2, 187, 154, 154)];
		[activityRingView _setRingDiameter:154 ringInterspacing:2 ringThickness:20];
		[activityRingView _setActivityRingViewBackgroundTransparent:YES];
		[activityRingView _setActivityRingViewBackgroundColor:nil];
		[self.backgroundView addSubview:activityRingView];
		
		activeEnergy = [[UILabel alloc] initWithFrame:CGRectMake(83.2, 126, 228.8, 94)];
		[activeEnergy setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[activeEnergy setTextColor:[UIColor colorWithRed:0.98 green:0.07 blue:0.31 alpha:1.0]];
		[activeEnergy setTextAlignment:NSTextAlignmentRight];
		[activeEnergy setText:@"---"];
		[self.contentView addSubview:activeEnergy];
		
		brisk = [[UILabel alloc] initWithFrame:CGRectMake(171.2, 196, 140.8, 94)];
		[brisk setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[brisk setTextColor:[UIColor colorWithRed:0.65 green:1 blue:0 alpha:1.0]];
		[brisk setTextAlignment:NSTextAlignmentRight];
		[brisk setText:@"---"];
		[self.contentView addSubview:brisk];
		
		movingHours = [[UILabel alloc] initWithFrame:CGRectMake(215.2, 266, 96.8, 94)];
		[movingHours setFont:[UIFont fontWithName:@".SFCompactRounded-Medium" size:78]];
		[movingHours setTextColor:[UIColor colorWithRed:0 green:0.96 blue:0.92 alpha:1.0]];
		[movingHours setTextAlignment:NSTextAlignmentRight];
		[movingHours setText:@"---"];
		[self.contentView addSubview:movingHours];
		
		// Preferences
		
		if (![watchFacePreferences objectForKey:@"style"]) {
			[self setFaceStyle:1];
		} else {
			[self setFaceStyle:[[watchFacePreferences objectForKey:@"style"] intValue]];
		}
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"white"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	[super updateForHour:hour minute:minute second:second millisecond:msecond animated:animated];
	
	UIColor* accentColor = [[WatchColors colors] objectForKey:[self accentColor]];
	
	long day = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:[NSDate date]];
	[self.dateLabel setText:[NSString stringWithFormat:@"%ld", day]];
	
	if (self.faceStyle == 0) {
		NSMutableAttributedString* timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:%02d", (int)hour, (int)minute]];
		for (int i=0; i<timeString.string.length; i++) {
			NSString* substring = [timeString.string substringWithRange:NSMakeRange(i, 1)];
			if ([substring isEqualToString:@":"]) {
				[timeString addAttributes:@{
											NSForegroundColorAttributeName: [UIColor clearColor]
											} range:NSMakeRange(i, 1)];
			}
		}
		
		[clockLabel setAttributedText:timeString];
		
		NSMutableAttributedString* colonString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:%02d", (int)hour, (int)minute]];
		for (int i=0; i<colonString.string.length; i++) {
			NSString* substring = [colonString.string substringWithRange:NSMakeRange(i, 1)];
			if ([substring isEqualToString:@":"]) {
				[colonString addAttributes:@{
											NSForegroundColorAttributeName: accentColor
											} range:NSMakeRange(i, 1)];
			}
		}
		
		[colonLabel setAttributedText:colonString];
		
		[secondsLabel1 setText:@""];
		[secondsLabel2 setText:@""];
	} else if (self.faceStyle == 1) {
		NSMutableAttributedString* timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:%02d:99", (int)hour, (int)minute]];
		
		[timeString addAttributes:@{
									NSForegroundColorAttributeName: [UIColor clearColor]
									} range:[[timeString string] rangeOfString:@"99"]];
		
		for (int i=0; i<timeString.string.length; i++) {
			NSString* substring = [timeString.string substringWithRange:NSMakeRange(i, 1)];
			if ([substring isEqualToString:@":"]) {
				[timeString addAttributes:@{
											NSForegroundColorAttributeName: [UIColor clearColor]
											} range:NSMakeRange(i, 1)];
			}
		}
		
		[clockLabel setAttributedText:timeString];
		
		NSMutableAttributedString* colonString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:%02d:99", (int)hour, (int)minute]];
		
		for (int i=0; i<colonString.string.length; i++) {
			NSString* substring = [colonString.string substringWithRange:NSMakeRange(i, 1)];
			if ([substring isEqualToString:@":"]) {
				[colonString addAttributes:@{
											 NSForegroundColorAttributeName:accentColor
											 } range:NSMakeRange(i, 1)];
			}
		}
		
		[colonLabel setAttributedText:colonString];
		
		NSString* secondsString = [NSString stringWithFormat:@"%02d", (int)second];
		[secondsLabel1 setText:[secondsString substringWithRange:NSMakeRange(0, 1)]];
		[secondsLabel2 setText:[secondsString substringWithRange:NSMakeRange(1,1)]];
	}
	
	if (cachedSecond != -1 && cachedSecond != second) {
		[colonLabel.layer removeAllAnimations];
		
		CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[fadeAnimation setToValue:[NSNumber numberWithFloat:0.35]];
		[fadeAnimation setDuration:1.0];
		[fadeAnimation setCumulative:YES];
		[colonLabel.layer addAnimation:fadeAnimation forKey:@"fade"];
	}
	
	cachedSecond = second;
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	
	[self updateActivityData];
	
	cachedSecond = -1;
	[colonLabel.layer removeAllAnimations];
}

- (void)didStopUpdatingTime {
	[super didStopUpdatingTime];
	
	[colonLabel.layer removeAllAnimations];
}

- (void)updateActivityData {
	activityData = [LWKActivityDataProvider activityData];
	HKActivitySummary* summary = [HKActivitySummary new];
	
	// Activity
	double activeEnergyBurnedGoal = [activityData[@"energy_burned_goal"] doubleValue];
	double activeEnergyBurned = [activityData[@"energy_burned"] doubleValue];
	[summary setActiveEnergyBurnedGoal:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:activeEnergyBurnedGoal]];
	[summary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:activeEnergyBurned]];

	[activeEnergy setText:[NSString stringWithFormat:@"%d", (int)activeEnergyBurned]];
	
	// Exercise
	double exerciseTimeGoal = [activityData[@"brisk_minutes_goal"] doubleValue];
	double exerciseTime = [activityData[@"brisk_minutes"] doubleValue];
	[summary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTimeGoal]];
	[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTime]];
	[brisk setText:[NSString stringWithFormat:@"%d", (int)exerciseTime]];
	
	// Move
	double standHoursGoal = [activityData[@"active_hours_goal"] doubleValue];
	double standHours = [activityData[@"active_hours"] doubleValue];
	[summary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHoursGoal]];
	[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHours]];
	[movingHours setText:[NSString stringWithFormat:@"%d", (int)standHours]];
	
	[activityRingView setActivitySummary:summary animated:NO];
}

#pragma mark - Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	[dateContainer setAlpha:(isEditing ? 0.15 : 1.0)];
	[activityRingView setAlpha:(isEditing ? 0.15 : 1.0)];
	[activeEnergy setAlpha:(isEditing ? 0.15 : 1.0)];
	[brisk setAlpha:(isEditing ? 0.15 : 1.0)];
	[movingHours setAlpha:(isEditing ? 0.15 : 1.0)];
}

// Style
- (void)setFaceStyle:(int)style {
	[super setFaceStyle:style];

	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:color];
	
	[clockLabel setTextColor:_color];
	NSMutableAttributedString* timeString = [clockLabel.attributedText mutableCopy];
	[timeString setAttributes:@{
								NSForegroundColorAttributeName: [UIColor clearColor]
								} range:[[timeString string] rangeOfString:@"99"]];
	for (int i=0; i<timeString.string.length; i++) {
		NSString* substring = [timeString.string substringWithRange:NSMakeRange(i, 1)];
		if ([substring isEqualToString:@":"]) {
			[timeString addAttributes:@{
										NSForegroundColorAttributeName: [UIColor clearColor]
										} range:NSMakeRange(i, 1)];
		}
	}
	
	[clockLabel setAttributedText:timeString];
	
	NSMutableAttributedString* colonString = [colonLabel.attributedText mutableCopy];
	for (int i=0; i<colonString.string.length; i++) {
		NSString* substring = [colonString.string substringWithRange:NSMakeRange(i, 1)];
		if ([substring isEqualToString:@":"]) {
			[colonString addAttributes:@{
										 NSForegroundColorAttributeName:_color
										 } range:NSMakeRange(i, 1)];
		}
	}
	
	[colonLabel setAttributedText:colonString];
	
	[secondsLabel1 setTextColor:_color];
	[secondsLabel2 setTextColor:_color];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"white";
	}
}

#pragma mark Customization delegate

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToLeftWithNextSelector:(LWKCustomizationSelector *)nextSelector scrollProgress:(CGFloat)scrollProgress {
	
}

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToRightWithPreviousSelector:(LWKCustomizationSelector *)prevSelector scrollProgress:(CGFloat)scrollProgress {
	
}

@end
