#import "LWKActivityAnalogFace.h"

@implementation LWKActivityAnalogFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView addSubview:backgroundView];
		
		UIImageView* dial = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dial" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
		[dial.layer setPosition:CGPointMake(156, 195)];
		[self.contentView insertSubview:dial atIndex:0];
		
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
		
		activeEnergy = [[UILabel alloc] initWithFrame:CGRectZero];
		[activeEnergy setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[activeEnergy setTextColor:[UIColor colorWithRed:1.0 green:0.53 blue:0.67 alpha:1]];
		[activeEnergy setText:@"---"];
		[activeEnergy sizeToFit];
		[activeEnergy setCenter:CGPointMake(156, 78)];
		[secondaryView addSubview:activeEnergy];
		
		briskRing = [HKRingsView ringsViewConfiguredForOneRingOnWatchOfType:1 withIcon:NO];
		[briskRing setFrame:CGRectMake(0, 0, 86, 86)];
		[briskRing setCenter:CGPointMake(78, 156)];
		[[[briskRing ringGroups] objectAtIndex:0] setRingDiameter:86];
		[[[briskRing ringGroups] objectAtIndex:0] setRingThickness:16];
		[[[briskRing ringGroups] objectAtIndex:0] setCenter:CGPointZero];
		[secondaryView addSubview:briskRing];
		
		brisk = [[UILabel alloc] initWithFrame:CGRectZero];
		[brisk setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[brisk setTextColor:[UIColor colorWithRed:0.92 green:1 blue:0.58 alpha:1]];
		[brisk setText:@"---"];
		[brisk sizeToFit];
		[brisk setCenter:CGPointMake(78, 156)];
		[secondaryView addSubview:brisk];
		
		movingHoursRing = [HKRingsView ringsViewConfiguredForOneRingOnWatchOfType:2 withIcon:NO];
		[movingHoursRing setFrame:CGRectMake(0, 0, 86, 86)];
		[movingHoursRing setCenter:CGPointMake(156, 234)];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setRingDiameter:86];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setRingThickness:16];
		[[[movingHoursRing ringGroups] objectAtIndex:0] setCenter:CGPointZero];
		[secondaryView addSubview:movingHoursRing];
		
		movingHours = [[UILabel alloc] initWithFrame:CGRectZero];
		[movingHours setFont:[UIFont fontWithName:@".SFCompactRounded-Semibold" size:25]];
		[movingHours setTextColor:[UIColor colorWithRed:0.53 green:0.97 blue:0.95 alpha:1]];
		[movingHours setText:@"---"];
		[movingHours sizeToFit];
		[movingHours setCenter:CGPointMake(156, 234)];
		[secondaryView addSubview:movingHours];
		
		//[self.contentView insertSubview:secondaryView atIndex:2];
		
		[self updateActivityData];
	}
	
	return self;
}

- (void)updateActivityData {
	NSDictionary* activityData = [LWKActivityDataProvider activityData];
	HKActivitySummary* summary = [HKActivitySummary new];
	
	if (activityData[@"energy_burned_goal"]) {
		[summary setActiveEnergyBurnedGoal:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:[activityData[@"energy_burned_goal"] doubleValue]]];
	}
	
	if (activityData[@"energy_burned"]) {
		[summary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:[activityData[@"energy_burned"] doubleValue]]];
	}
	
	if (activityData[@"brisk_minutes"]) {
		[summary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:30]];
		[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:[activityData[@"brisk_minutes"] doubleValue]]];
	}
	
	if (activityData[@"active_hours"]) {
		[summary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:12]];
		[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:[activityData[@"active_hours"] doubleValue]]];
	}
	
	[activityRingView setActivitySummary:summary animated:NO];
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	[self updateActivityData];
}

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
	} else {
		[self updateActivityData];
	}
}

- (NSArray*)focussedViewsForEditingPage:(int)page {
	switch (page) {
		case 0:
			return @[mainView, secondaryView];
			break;
			
		default:
			return nil;
	}
}

@end
