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
		
		activityRingView = [[HKActivityRingView alloc] initWithFrame:CGRectMake(0, 0, 242, 242)];
		[activityRingView.layer setPosition:CGPointMake(156, 195)];
		[activityRingView _setRingDiameter:242 ringInterspacing:4 ringThickness:23];
		[activityRingView _setActivityRingViewBackgroundTransparent:YES];
		[activityRingView _setActivityRingViewBackgroundColor:nil];
		[self.contentView insertSubview:activityRingView atIndex:1];
		
		[self updateActivityData];
	}
	
	return self;
}

- (void)updateActivityData {
	NSDictionary* activityData = [LWKActivityDataProvider activityData];
	HKActivitySummary* summary = [HKActivitySummary new];
	
	if (activityData[@"LatestCalorieBurnGoalMetCalories"]) {
		[summary setActiveEnergyBurnedGoal:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:[activityData[@"LatestCalorieBurnGoalMetCalories"] doubleValue]]];
	}
	
	if (activityData[@"CaloriesBurnedToday"]) {
		[summary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:[activityData[@"CaloriesBurnedToday"] doubleValue]]];
	}
	
	if (activityData[@"BriskMinutesToday"]) {
		[summary setAppleExerciseTimeGoal:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:30]];
		[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:[activityData[@"BriskMinutesToday"] doubleValue]]];
	}
	
	if (activityData[@"StandingHoursToday"]) {
		[summary setAppleStandHoursGoal:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:12]];
		[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:[activityData[@"StandingHoursToday"] doubleValue]]];
	}
	
	[activityRingView setActivitySummary:summary animated:NO];
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
			return @[activityRingView];
			break;
			
		default:
			return nil;
	}
}

@end
