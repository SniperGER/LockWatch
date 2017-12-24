#import "LWKExtraLargeFace.h"

@implementation LWKExtraLargeFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 390) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setCornerRadius:10];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 312, 195)];
		[hourLabel setFont:[UIFont fontWithName:@".SFCompactDisplay-Regular" size:220]];
		[hourLabel setTextAlignment:NSTextAlignmentRight];
		[self.contentView addSubview:hourLabel];
		
		minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 312, 195)];
		[minuteLabel setFont:[UIFont fontWithName:@".SFCompactDisplay-Regular" size:220]];
		[minuteLabel setTextAlignment:NSTextAlignmentRight];
		[minuteLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.contentView addSubview:minuteLabel];
		
		colonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 312, 195)];
		[colonLabel setFont:[UIFont fontWithName:@".SFCompactDisplay-Regular" size:220]];
		[colonLabel setTextAlignment:NSTextAlignmentRight];
		[colonLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.contentView addSubview:colonLabel];
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"blue"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	[hourLabel setText:[NSString stringWithFormat:@"%d", (int)hour]];
	[minuteLabel setText:[NSString stringWithFormat:@"%02d", (int)minute]];
	
	NSMutableAttributedString* colonString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@":%02d", (int)minute]];
	[colonString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(1, 2)];
	[colonLabel setAttributedText:colonString];
}

#pragma mark Customization

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:[self accentColor]];
	[hourLabel setTextColor:_color];
	[minuteLabel setTextColor:_color];
	[colonLabel setTextColor:_color];
	
	if (colonLabel.text) {
		NSMutableAttributedString* colonString = [[NSMutableAttributedString alloc] initWithString:colonLabel.text];
		[colonString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(1, 2)];
		[colonLabel setAttributedText:colonString];
	}
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"blue";
	}
}

@end
