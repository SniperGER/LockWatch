#import "LWKColorAnalogFace.h"

@implementation LWKColorAnalogFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		indicatorImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"color" inBundle:self.watchFaceBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		[indicatorImage setCenter:CGPointMake(156, 195)];
		
		[self.contentView addSubview:indicatorImage];
		
		if (![watchFacePreferences objectForKey:@"accentColor"]) {
			[self setAccentColor:@"blue"];
		} else {
			[self setAccentColor:[watchFacePreferences objectForKey:@"accentColor"]];
		}
	}

	return self;
}

#pragma mark Customization

- (void)setIsEditing:(BOOL)isEditing {
	[super setIsEditing:isEditing];
	
	if (isEditing) {
		[self.indicatorView setAlpha:0.0];
		[self.contentView setAlpha:1.0];
	}
}

// Accent Color
- (void)setAccentColor:(NSString *)color {
	[super setAccentColor:color];
	
	UIColor* _color = [[WatchColors colors] objectForKey:color];
	[indicatorImage setTintColor:_color];
	[self.secondHand setTintColor:[WatchColors lightOrangeColor]];
}

- (NSString*)accentColor {
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"accentColor"]) {
		return [super accentColor];
	} else {
		return @"blue";
	}
}


@end
