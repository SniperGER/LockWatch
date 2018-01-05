#import "LWKNumeralsAnalogFace.h"
#import "LWKCustomizationSelector.h"

@implementation LWKNumeralsAnalogFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 390) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setCornerRadius:10];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		numeralImageContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 230, 230)];
		[self.backgroundView addSubview:numeralImageContainer];
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"lightOrange"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	hour = (hour > 12 || hour <= 0) ? ABS(hour - 12) : hour;
	[super updateForHour:hour minute:minute second:second millisecond:msecond animated:animated];
	
	[self updateNumeralImagesForHour:hour];
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	
	NSDate* date = [NSDate date];
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents* hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	
	float hour = [hourComp hour];
	
	hour = (hour > 12 || hour <= 0) ? ABS(hour - 12) : hour;
	[self updateNumeralImagesForHour:hour];
}

- (void)didStopUpdatingTime {
	[super didStopUpdatingTime];
	
	[self updateNumeralImagesForHour:10];
}

#pragma mark Numeral Images

- (void)updateNumeralImagesForHour:(double)hour {
	NSString* numeralType = @"regular";
	
	switch (self.faceStyle) {
		case 0:
			numeralType = @"regular";
			break;
		case 1:
			numeralType = @"rounded";
			break;
		default: break;
	}
	
	UIImage* hourImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%d", numeralType, (int)hour] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[numeralImageContainer setImage:hourImage];
	
	CGFloat posX = 0;
	CGFloat posY = 0;
	
	switch ((int)hour) {
		case 1:
		case 2:
			posX = 232;
			posY = 80;
			break;
		case 3:
			posX = 232;
			posY = 195;
			break;
		case 4:
		case 5:
			posX = 232;
			posY = 310;
			break;
		case 6:
			posX = 156;
			posY = 310;
			break;
		case 7:
		case 8:
			posX = 80;
			posY = 310;
			break;
		case 9:
			posX = 80;
			posY = 195;
			break;
		case 10:
		case 11:
			posX = 80;
			posY = 80;
			break;
		case 12:
			posX = 156;
			posY = 80;
			break;
		default:
			break;
	}
	
	[numeralImageContainer setCenter:CGPointMake(posX, posY)];
}

#pragma mark - Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	if (isEditing) {
		[numeralImageContainer setAlpha:1.0];
		[self.hourHand setAlpha:0.15];
		[self.minuteHand setAlpha:0.15];
		
		if ([currentCustomizationSelector.type isEqualToString:@"style"]) {
			[self.secondHand setAlpha:0.15];
		} else if ([currentCustomizationSelector.type isEqualToString:@"color"]) {
			[self.secondHand setAlpha:1.0];
		}
	} else {
		[numeralImageContainer setAlpha:1.0];
		[self.hourHand setAlpha:1.0];
		[self.minuteHand setAlpha:1.0];
		[self.secondHand setAlpha:1.0];
	}
}

// Style
- (void)setFaceStyle:(int)style {
	[super setFaceStyle:style];
	
	[self updateNumeralImagesForHour:10];
}

- (int)faceStyle {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"style"]) {
		return [super faceStyle];
	} else {
		return 0;
	}
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:color];
	[numeralImageContainer setTintColor:_color];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"lightOrange";
	}
}

#pragma mark Customization delegate

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToLeftWithNextSelector:(LWKCustomizationSelector *)nextSelector scrollProgress:(CGFloat)scrollProgress {
	if ([nextSelector.type isEqualToString:@"color"]) {
		[self.secondHand setAlpha:MAX(scrollProgress, 0.15)];
	}
}

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToRightWithPreviousSelector:(LWKCustomizationSelector *)prevSelector scrollProgress:(CGFloat)scrollProgress {
	if ([selector.type isEqualToString:@"style"]) {
		[self.secondHand setAlpha:MAX(1 - scrollProgress, 0.15)];
	}
}

@end
