#import "LWKUtilitarianNumbersFace.h"

@implementation LWKUtilitarianNumbersFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		if (![watchFacePreferences objectForKey:@"detail"]) {
			[self setFaceDetail:0];
		} else {
			[self setFaceDetail:[[watchFacePreferences objectForKey:@"detail"] intValue]];
		}
	}
	
	return self;
}

#pragma mark Customization

- (BOOL)isCustomizable {
	return NO;
}

// Detail
- (int)faceDetail{
	if (watchFacePreferences && [watchFacePreferences objectForKey:@"detail"]) {
		return [super faceDetail];
	} else {
		return 0;
	}
}

@end
