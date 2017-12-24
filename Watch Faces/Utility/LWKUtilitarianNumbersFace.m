#import "LWKUtilitarianNumbersFace.h"

@implementation LWKUtilitarianNumbersFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.indicatorView insertSubview:self.dateLabel atIndex:0];
		[self updateDateLabel];
		
		if (![watchFacePreferences objectForKey:@"detail"]) {
			[self setFaceDetail:0];
		} else {
			[self setFaceDetail:[[watchFacePreferences objectForKey:@"detail"] intValue]];
		}
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"lightOrange"];
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

#pragma mark Additional Methods

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
	
	NSString* dateString = [NSString stringWithFormat:@"%ld", day];
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:dateString];
	[attributedText setAttributes:@{
									NSForegroundColorAttributeName: [UIColor whiteColor],
									NSFontAttributeName: [UIFont fontWithName:@".SFCompactText-Regular" size:34]
									} range:[dateString rangeOfString:dayName]];
	[attributedText setAttributes:@{
									NSForegroundColorAttributeName:_color,
									NSFontAttributeName: [UIFont fontWithName:@".SFCompactText-Regular" size:34]
									} range:[dateString rangeOfString:[NSString stringWithFormat:@"%ld", day]]];
	[self.dateLabel setAttributedText:attributedText];
	[self.dateLabel sizeToFit];
	[self.dateLabel setCenter:CGPointMake(218, 156)];
}

#pragma mark Customization

// Detail
- (int)faceDetail{
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"detail"]) {
		return [super faceDetail];
	} else {
		return 0;
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

@end
