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
		[clockLabel setTextColor:[UIColor whiteColor]];
		[clockLabel setTextAlignment:NSTextAlignmentCenter];
		[clockLabel setText:@"10:09:30"];
		[self.contentView addSubview:clockLabel];
		
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
	
	NSString* timeString = [NSString stringWithFormat:@"%d:%02d:%02d", (int)hour, (int)minute, (int)second];
	[clockLabel setText:timeString];
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	[self updateActivityData];
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

#pragma mark Customization

// Accent Color
- (void)setAccentColor:(NSString *)color {
	UIColor* _color = [[WatchColors colors] objectForKey:color];
	
	[clockLabel setTextColor:_color];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"white";
	}
}

@end
