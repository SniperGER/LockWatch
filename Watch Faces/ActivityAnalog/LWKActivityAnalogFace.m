#import "LWKActivityAnalogFace.h"
#import "LWKCustomizationSelector.h"

@implementation LWKActivityAnalogFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];

		dial = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 310)];
		[dial.layer setPosition:CGPointMake(156, 195)];
		[self.backgroundView addSubview:dial];
		
		// Main View
		mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
		[mainView setCenter:CGPointMake(156, 195)];
		
		activityRingView = [[HKActivityRingView alloc] initWithFrame:CGRectMake(0, 0, 242, 242)];
		[activityRingView.layer setPosition:CGPointMake(156, 156)];
		[activityRingView _setRingDiameter:242 ringInterspacing:4 ringThickness:23];
		[activityRingView _setActivityRingViewBackgroundTransparent:YES];
		[activityRingView _setActivityRingViewBackgroundColor:nil];
		[mainView addSubview:activityRingView];
		
		[self.contentView insertSubview:mainView atIndex:1];
		
		// Secondary View
		secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
		[secondaryView setCenter:CGPointMake(156, 195)];
		
		activeEnergyRing = [HKRingsView ringsViewConfiguredForOneRingOnWatchOfType:0 withIcon:NO];
		[activeEnergyRing setFrame:CGRectMake(0, 0, 86, 86)];
		[activeEnergyRing setCenter:CGPointMake(156, 78)];
		[[[activeEnergyRing ringGroups] objectAtIndex:0] setRingDiameter:86];
		[[[activeEnergyRing ringGroups] objectAtIndex:0] setRingThickness:16];
		[[[activeEnergyRing ringGroups] objectAtIndex:0] setCenter:CGPointZero];
		[secondaryView addSubview:activeEnergyRing];
		
		activeEnergy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 36)];
		[activeEnergy setTextAlignment:NSTextAlignmentCenter];
		[activeEnergy setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[activeEnergy setTextColor:[UIColor colorWithRed:1.0 green:0.53 blue:0.67 alpha:1]];
		[activeEnergy setText:@"---"];
		[activeEnergy setCenter:CGPointMake(156, 78)];
		[secondaryView addSubview:activeEnergy];
		
		briskRing = [HKRingsView ringsViewConfiguredForOneRingOnWatchOfType:1 withIcon:NO];
		[briskRing setFrame:CGRectMake(0, 0, 86, 86)];
		[briskRing setCenter:CGPointMake(78, 156)];
		[[[briskRing ringGroups] objectAtIndex:0] setRingDiameter:86];
		[[[briskRing ringGroups] objectAtIndex:0] setRingThickness:16];
		[[[briskRing ringGroups] objectAtIndex:0] setCenter:CGPointZero];
		[secondaryView addSubview:briskRing];
		
		brisk = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 36)];
		[brisk setTextAlignment:NSTextAlignmentCenter];
		[brisk setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[brisk setTextColor:[UIColor colorWithRed:0.92 green:1 blue:0.58 alpha:1]];
		[brisk setText:@"---"];
		[brisk setCenter:CGPointMake(78, 156)];
		[secondaryView addSubview:brisk];
		
		movingHoursRing = [HKRingsView ringsViewConfiguredForOneRingOnWatchOfType:2 withIcon:NO];
		[movingHoursRing setFrame:CGRectMake(0, 0, 86, 86)];
		[movingHoursRing setCenter:CGPointMake(156, 234)];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setRingDiameter:86];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setRingThickness:16];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setCenter:CGPointZero];
		[secondaryView addSubview:movingHoursRing];
		
		movingHours = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 36)];
		[movingHours setTextAlignment:NSTextAlignmentCenter];
		[movingHours setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[movingHours setTextColor:[UIColor colorWithRed:0.53 green:0.97 blue:0.95 alpha:1]];
		[movingHours setText:@"---"];
		[movingHours setCenter:CGPointMake(156, 234)];
		[secondaryView addSubview:movingHours];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[secondaryView addSubview:dateLabel];
		
		[self.contentView insertSubview:secondaryView atIndex:2];
		[secondaryView setAlpha:0];
		
		// Preferences
		
		if (![watchFacePreferences objectForKey:@"style"]) {
			[self setFaceStyle:0];
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
	
	[self updateDateLabel];
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	[self updateActivityData];
}

#pragma mark Additional Methods

- (void)updateActivityData {
	activityData = [LWKActivityDataProvider activityData];
	HKActivitySummary* summary = [HKActivitySummary new];
	
	// Activity
	double activeEnergyBurnedGoal = MAX([activityData[@"energy_burned_goal"] doubleValue], 1);
	double activeEnergyBurned = [activityData[@"energy_burned"] doubleValue];
	[summary setActiveEnergyBurnedGoal:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:activeEnergyBurnedGoal]];
	[summary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:activeEnergyBurned]];
	[activeEnergyRing setMovingHoursPercentage:(activeEnergyBurned / activeEnergyBurnedGoal) animated:NO];
	[activeEnergy setText:[NSString stringWithFormat:@"%d", (int)activeEnergyBurned]];
	
	// Exercise
	double exerciseTimeGoal = MAX([activityData[@"brisk_minutes_goal"] doubleValue], 1);
	double exerciseTime = [activityData[@"brisk_minutes"] doubleValue];
	[summary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTimeGoal]];
	[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:exerciseTime]];
	[briskRing setMovingHoursPercentage:(exerciseTime / exerciseTimeGoal) animated:NO];
	[brisk setText:[NSString stringWithFormat:@"%d", (int)exerciseTime]];
	
	// Move
	double standHoursGoal = MAX([activityData[@"active_hours_goal"] doubleValue], 1);
	double standHours = [activityData[@"active_hours"] doubleValue];
	[summary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHoursGoal]];
	[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:standHours]];
	[movingHoursRing setMovingHoursPercentage:(exerciseTime / exerciseTimeGoal) animated:NO];
	[movingHours setText:[NSString stringWithFormat:@"%d", (int)standHours]];
	
	[activityRingView setActivitySummary:summary animated:NO];
}

- (void)updateDateLabel {
	UIColor* _color = [[WatchColors colors] objectForKey:[self accentColor]];
	if (CGColorEqualToColor(_color.CGColor, [WatchColors whiteColor].CGColor)) {
		_color = [WatchColors lightOrangeColor];
	}
	
	NSDate* date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	
	NSString *dayName = [[[dateFormatter stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 3)] uppercaseString];
	long day = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:date];
	
	NSString* dateString = [NSString stringWithFormat:@"%@ %ld", dayName, day];
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:dateString];
	[attributedText setAttributes:@{
									NSForegroundColorAttributeName: [UIColor whiteColor],
									NSFontAttributeName: [UIFont fontWithName:@".SFCompactRounded-Semibold" size:26]
									} range:[dateString rangeOfString:dayName]];
	[attributedText setAttributes:@{
									NSForegroundColorAttributeName:_color,
									NSFontAttributeName: [UIFont fontWithName:@".SFCompactRounded-Semibold" size:26]
									} range:[dateString rangeOfString:[NSString stringWithFormat:@"%ld", day]]];
	[dateLabel setAttributedText:attributedText];
	[dateLabel sizeToFit];
	[dateLabel setCenter:CGPointMake(220, 156)];
}

#pragma mark Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	if (isEditing) {
		HKActivitySummary* demoSummary = [HKActivitySummary new];
		
		[demoSummary setActiveEnergyBurnedGoal:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:1]];
		[demoSummary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:1]];
		
		[demoSummary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:1]];
		[demoSummary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:1]];
		
		[demoSummary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:1]],
		[demoSummary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:1]];
		
		[activityRingView setActivitySummary:demoSummary animated:NO];
		
		// A single HKRingView needs to be updated with setMovingHoursPercentage:animated:
		[activeEnergyRing setMovingHoursPercentage:1.0 animated:NO];
		[briskRing setMovingHoursPercentage:1.0 animated:NO];
		[movingHoursRing setMovingHoursPercentage:1.0 animated:NO];
		
		double activeEnergyBurnedGoal = [activityData[@"energy_burned_goal"] doubleValue];
		double exerciseTimeGoal = [activityData[@"brisk_minutes_goal"] doubleValue];
		double standHoursGoal = [activityData[@"active_hours_goal"] doubleValue];
		
		[activeEnergy setText:[NSString stringWithFormat:@"%d", (int)activeEnergyBurnedGoal]];
		[brisk setText:[NSString stringWithFormat:@"%d", (int)exerciseTimeGoal]];
		[movingHours setText:[NSString stringWithFormat:@"%d", (int)standHoursGoal]];
		
		[self.indicatorView setHidden:YES];
		if ([currentCustomizationSelector isKindOfClass:NSClassFromString(@"LWKStyleCustomizationSelector")]) {
			[dial setAlpha:0.0];
		} else if ([currentCustomizationSelector isKindOfClass:NSClassFromString(@"LWKColorCustomizationSelector")]) {
			[dial setAlpha:1.0];
		}
	} else {
		[self updateActivityData];
		
		[self.indicatorView setHidden:NO];
		[dial setAlpha:1.0];
	}
}

// Style
- (NSArray*)faceStyleViews {
	return @[mainView, secondaryView];
}

- (void)setFaceStyle:(int)style {
	[mainView setAlpha:(style == 0 ? 1 : 0)];
	[secondaryView setAlpha:(style == 1 ? 1 : 0)];
	
	[super setFaceStyle:style];
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:color];
	if (CGColorEqualToColor(_color.CGColor, [WatchColors whiteColor].CGColor)) {
		[self.secondHand setTintColor:[WatchColors lightOrangeColor]];
	}
	
	[[dial.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
	[dial.layer addSublayer:[self makeIndicatorsWithAccentColor:_color]];
	[self updateDateLabel];
}

- (CALayer*)makeIndicatorsWithAccentColor:(UIColor*)accentColor {
	CALayer* dialLayer = [CALayer layer];
	
	// Ring
	CAShapeLayer* ringLayer = [CAShapeLayer layer];
	[ringLayer setStrokeColor:[accentColor colorWithAlphaComponent:0.12].CGColor];
	[ringLayer setFillColor:nil];
	[ringLayer setLineWidth:16.0];
	[ringLayer setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectInset(dial.bounds, 8, 8)].CGPath];
	[dialLayer addSublayer:ringLayer];
	
	// Highlights
	CAShapeLayer* highlightLayer = [CAShapeLayer layer];
	[highlightLayer setStrokeColor:[accentColor colorWithAlphaComponent:0.75].CGColor];
	[highlightLayer setLineWidth:4.0];
	
	UIBezierPath* path = [[UIBezierPath alloc] init];
	for (int i=0; i<12; i++) {
		CGFloat angle = deg2rad(i*30);
			CGFloat innerRadius = 139;
			CGFloat outerRadius = 155;
			
			CGPoint inner = CGPointMake((innerRadius * sin(angle)) + (310/2), (innerRadius * -cos(angle)) + (310/2));
			CGPoint outer = CGPointMake((outerRadius * sin(angle)) + (310/2), (outerRadius * -cos(angle)) + (310/2));
			
			[path moveToPoint:inner];
			[path addLineToPoint:outer];
	}
	
	[highlightLayer setPath:path.CGPath];
	[dialLayer addSublayer:highlightLayer];
	
	return dialLayer;
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"white";
	}
}

@end
