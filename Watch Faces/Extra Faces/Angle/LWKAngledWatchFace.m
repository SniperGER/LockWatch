#import "LWKAngledWatchFace.h"

@implementation LWKAngledWatchFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 390) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setCornerRadius:10];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		[self.backgroundView setClipsToBounds:YES];
		
		// 0,205378
		angledView = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, 342, 140)];
		[angledView setCenter:CGPointMake(156, 70 + 20.5378 + 20)];
		[angledView setTransform:CGAffineTransformMakeRotation(deg2rad(-7.5))];
		[angledView.layer setShouldRasterize:YES];
		[angledView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[self.backgroundView addSubview:angledView];
		
		//[UIFont registerFontFromURL:[NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class] pathForResource:@"FuturaBoldCondensedOblique" ofType:@"otf"]]];
		
		NSString* fontPath = [NSString stringWithFormat:@"%@/Victoria-CondensedBoldOblique.otf", self.watchFaceBundle.bundlePath];
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:fontPath]];
		
		clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 312, 140)];
		[clockLabel setFont:[UIFont fontWithName:@"Victoria-CondensedBoldOblique" size:130]];
		[clockLabel setTextAlignment:NSTextAlignmentCenter];
		[clockLabel setAdjustsFontSizeToFitWidth:YES];
		[clockLabel setCenter:CGPointMake(342/2 - 7.5, 140/2 + 15)];
		[angledView addSubview:clockLabel];
		
		colonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 312, 140)];
		[colonLabel setFont:[UIFont fontWithName:@"Victoria-CondensedBoldOblique" size:130]];
		[colonLabel setTextAlignment:NSTextAlignmentCenter];
		[colonLabel setAdjustsFontSizeToFitWidth:YES];
		[colonLabel setCenter:CGPointMake(342/2 - 7.5, 140/2)];
		[colonLabel setTextColor:[UIColor clearColor]];
		[angledView addSubview:colonLabel];
		
		dateContainer = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 50, 50)];
		[dateContainer setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1.0]];
		[dateContainer.layer setCornerRadius:25.0];
		[self.contentView addSubview:dateContainer];
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50 - 5, 50 + 5)];
		[self.dateLabel setTextAlignment:NSTextAlignmentCenter];
		[self.dateLabel setTextColor:[UIColor blackColor]];
		[self.dateLabel setFont:[UIFont fontWithName:@"Victoria-CondensedBoldOblique" size:30]];
		[self.dateLabel setTransform:CGAffineTransformMakeRotation(deg2rad(-7.5))];
		[dateContainer addSubview:self.dateLabel];
		
		activityRingView = [[HKActivityRingView alloc] initWithFrame:CGRectMake(186, 187, 124, 124)];
		[activityRingView _setRingDiameter:124 ringInterspacing:2 ringThickness:16];
		[activityRingView _setActivityRingViewBackgroundTransparent:YES];
		[activityRingView _setActivityRingViewBackgroundColor:nil];
		[self.backgroundView addSubview:activityRingView];
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"red"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond startAnimation:(BOOL)startAnimation {
	long day = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:[NSDate date]];
	[self.dateLabel setText:[NSString stringWithFormat:@"%ld", day]];
	
	NSString* clockText = [NSString stringWithFormat:@"%d:%02d", (int)hour, (int)minute];
	
	NSMutableAttributedString* clockString = [[NSMutableAttributedString alloc] initWithString:clockText];
	[clockString addAttributes:@{
								 NSForegroundColorAttributeName: [UIColor clearColor]
								 } range:[clockText rangeOfString:@":"]];
	[clockLabel setAttributedText:clockString];
	
	NSMutableAttributedString* colonString = [[NSMutableAttributedString alloc] initWithString:clockText];
	[colonString addAttributes:@{
								 NSForegroundColorAttributeName: [UIColor blackColor]
								 } range:[clockText rangeOfString:@":"]];
	[colonLabel setAttributedText:colonString];
	
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

- (void)didStartUpdatingTime:(BOOL)animated {
	[super didStartUpdatingTime:animated];
	
	[self updateActivityData];
	
	cachedSecond = -1;
	[colonLabel.layer removeAllAnimations];
}

- (void)didStopUpdatingTime:(BOOL)animated {
	[super didStopUpdatingTime:animated];
	
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
	
	// Exercise
	double exerciseTimeGoal = [activityData[@"brisk_minutes_goal"] doubleValue];
	double exerciseTime = [activityData[@"brisk_minutes"] doubleValue];
	[summary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTimeGoal]];
	[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTime]];
	
	// Move
	double standHoursGoal = [activityData[@"active_hours_goal"] doubleValue];
	double standHours = [activityData[@"active_hours"] doubleValue];
	[summary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHoursGoal]];
	[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHours]];
	
	[activityRingView setActivitySummary:summary animated:NO];
}

#pragma mark Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	[dateContainer setAlpha:(isEditing ? 0.15 : 1.0)];
	[activityRingView setAlpha:(isEditing ? 0.15 : 1.0)];
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:[self accentColor]];
	[angledView setBackgroundColor:_color];
	[dateContainer setBackgroundColor:_color];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"red";
	}
}

@end
