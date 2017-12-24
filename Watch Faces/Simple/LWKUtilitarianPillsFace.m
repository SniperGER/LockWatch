#import "LWKUtilitarianPillsFace.h"

@implementation LWKUtilitarianPillsFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.indicatorView insertSubview:self.dateLabel atIndex:0];
		
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
	}
	
	return self;
}

#pragma mark Customization

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
	
	//[self updateDateLabel];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"lightOrange";
	}
}

@end
