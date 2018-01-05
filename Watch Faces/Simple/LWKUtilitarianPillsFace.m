#import "LWKUtilitarianPillsFace.h"
#import "LWKCustomizationSelector.h"

@implementation LWKUtilitarianPillsFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		dateLabelDetail = 0;
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.indicatorView insertSubview:self.dateLabel atIndex:0];
		[self updateDateLabel];
		
		if (![watchFacePreferences objectForKey:@"detail"]) {
			[self setFaceDetail:1];
		} else {
			[self setFaceDetail:[[watchFacePreferences objectForKey:@"detail"] intValue]];
		}
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"lightOrange"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
		
		if (!watchFacePreferences[@"complications"]) {
			[self setComplicationIndex:0 forPosition:@"date"];
		} else {
			[self setComplicationIndex:[watchFacePreferences[@"complications"][@"date"] intValue] forPosition:@"date"];
		}
	}
	
	return self;
}

#pragma mark - Additional Methods

- (void)updateDateLabel {
	UIColor* _color = [[WatchColors colors] objectForKey:[self accentColor]];
	if (CGColorEqualToColor(_color.CGColor, [WatchColors whiteColor].CGColor)) {
		_color = [WatchColors lightOrangeColor];
	}
	
	NSDate* date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	
	long day = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:date];
	
	if (dateLabelDetail == 0) {
		[self.dateLabel setText:@""];
	} else if (dateLabelDetail == 1) {
		NSString* dateString = [NSString stringWithFormat:@"%ld", day];
		NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:dateString];
		
		[attributedText setAttributes:@{
										NSForegroundColorAttributeName:_color,
										NSFontAttributeName: [UIFont fontWithName:@".SFCompactText-Regular" size:34]
										} range:[dateString rangeOfString:[NSString stringWithFormat:@"%ld", day]]];
		[self.dateLabel setAttributedText:attributedText];
	}
	
	[self.dateLabel sizeToFit];
	[self.dateLabel setCenter:CGPointMake(223, 156)];
}

#pragma mark - Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	if (isEditing) {
		if ([currentCustomizationSelector.type isEqualToString:@"detail"]) {
			[self.contentView setAlpha:1];
			[self.hourHand setAlpha:0.0];
			[self.minuteHand setAlpha:0.0];
			[self.secondHand setAlpha:0.0];
			[self.dateLabel setAlpha:0.15];
		} else if ([currentCustomizationSelector.type isEqualToString:@"color"]) {
			[self.contentView setAlpha:0.15];
			[self.hourHand setAlpha:0.15];
			[self.minuteHand setAlpha:0.15];
			[self.secondHand setAlpha:1];
			[self.dateLabel setAlpha:0.15];
		} else if ([currentCustomizationSelector.type isEqualToString:@"complications"]) {
			[self.contentView setAlpha:0.15];
			[self.hourHand setAlpha:0.15];
			[self.minuteHand setAlpha:0.15];
			[self.secondHand setAlpha:0.15];
			[self.dateLabel setAlpha:1];
		}
	} else {
		[self.contentView setAlpha:1];
		[self.hourHand setAlpha:1];
		[self.minuteHand setAlpha:1];
		[self.secondHand setAlpha:1];
		[self.dateLabel setAlpha:1];
	}
}

// Detail
- (int)faceDetail{
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"detail"]) {
		return [super faceDetail];
	} else {
		return 1;
	}
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	[self updateDateLabel];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"lightOrange";
	}
}

// Complications
- (void)setComplicationIndex:(int)index forPosition:(NSString *)position {
	[super setComplicationIndex:index forPosition:position];
	if ([position isEqualToString:@"date"]) {
		dateLabelDetail = index;
		[self updateDateLabel];
	}
}

- (int)complicationIndexForPosition:(NSString *)position {
	if ([position isEqualToString:@"date"]) {
		if (watchFacePreferences && watchFacePreferences[@"complications"][@"date"]) {
			return [watchFacePreferences[@"complications"][@"date"] intValue];
		} else {
			return 0;
		}
	}
	
	return -1;
}


#pragma mark Customization delegate

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToLeftWithNextSelector:(LWKCustomizationSelector *)nextSelector scrollProgress:(CGFloat)scrollProgress {
	if ([nextSelector.type isEqualToString:@"color"]) {
		[self.contentView setAlpha:MAX(1 - scrollProgress, 0.15)];
		[self.hourHand setAlpha:MIN(scrollProgress, 0.15)];
		[self.minuteHand setAlpha:MIN(scrollProgress, 0.15)];
		[self.secondHand setAlpha:scrollProgress];
	} else if ([nextSelector.type isEqualToString:@"complications"]) {
		[self.secondHand setAlpha:MAX(1 - scrollProgress, 0.15)];
		[self.dateLabel setAlpha:MAX(scrollProgress, 0.15)];
	}
}

- (void)customizationSelector:(LWKCustomizationSelector *)selector didScrollToRightWithPreviousSelector:(LWKCustomizationSelector *)prevSelector scrollProgress:(CGFloat)scrollProgress {
	if ([selector.type isEqualToString:@"detail"]) {
		[self.contentView setAlpha:MAX(scrollProgress, 0.15)];
		[self.hourHand setAlpha:MIN(1 - scrollProgress, 0.15)];
		[self.minuteHand setAlpha:MIN(1 - scrollProgress, 0.15)];
		[self.secondHand setAlpha:MIN(1 - scrollProgress, 1)];
	} else if ([selector.type isEqualToString:@"color"]) {
		[self.secondHand setAlpha:MAX(scrollProgress, 0.15)];
		[self.dateLabel setAlpha:MAX(1 - scrollProgress, 0.15)];
	}
}

@end
