#import "LockWatchKit.h"
#import "LWKCustomizationSelector.h"

@interface LWPreferences : NSObject
+ (id)sharedInstance;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
@end

@implementation LWKClockBase

- (id)init {
	if (self = [super init]) {
		_clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		
		_indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
		[_indicatorView setCenter:CGPointMake(156, 195)];
		
		[_clockView addSubview:_backgroundView];
		[_clockView addSubview:_contentView];
		[_clockView addSubview:_indicatorView];
		
		_watchFaceBundle = [NSBundle bundleForClass:self.class];
		/*watchFacePreferences = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]]];
		
		if (!watchFacePreferences) {
			watchFacePreferences = [NSMutableDictionary new];
			[watchFacePreferences writeToFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]] atomically:YES];
		}*/
		
		watchFacePreferences = [[[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] objectForKey:[_watchFaceBundle bundleIdentifier]] mutableCopy];
		if (!watchFacePreferences) {
			watchFacePreferences = [NSMutableDictionary new];
			
			NSMutableDictionary* preferencesContainer = [[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] mutableCopy];
			[preferencesContainer setObject:watchFacePreferences forKey:[_watchFaceBundle bundleIdentifier]];
			
			[[objc_getClass("LWPreferences") sharedInstance] setObject:preferencesContainer forKey:@"watchFacePreferences"];
		}
		
		[self prepareCustomizationMode];
	}
	
	return self;
}

- (void)prepareForInit {
	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	
}
- (void)didStartUpdatingTime {}
- (void)didStopUpdatingTime {}

#pragma mark Customization

- (void)prepareCustomizationMode {
	customizationOptions = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"Customization" ofType:@"plist"]];
	
	if (customizationOptions) {
		if (customizationOptions.count > 1 && ![self conformsToProtocol:@protocol(LWKCustomizationDelegate)]) {
			NSLog(@"[LockWatchKit] Watch face %@ has multiple customization options, but does not conform to LWKCustomizationDelegate. NOT CUSTOMIZABLE!", NSStringFromClass(self.class));
			return;
		}
		
		_isCustomizable = YES;
		
		_editView = [[LWKFaceEditView alloc] initWithFrame:CGRectMake(0, 0, 312, 390) options:customizationOptions forWatchFace:self];
		[_editView setHidden:YES];
		[_clockView addSubview:_editView];
	}
}

- (void)setIsEditing:(BOOL)isEditing {
	_isEditing = isEditing;
	
	[_editView setHidden:!isEditing];
	
	if (isEditing) {
		CGFloat page = MAX(MIN(ceilf(_editView.scrollView.contentOffset.x / 312), customizationOptions.count - 1), 0);
		LWKCustomizationSelector* selector = [_editView.pages objectAtIndex:page];
		currentCustomizationSelector = selector;
		
		for (LWKCustomizationSelector* _selector in _editView.pages) {
			if (_selector != selector) {
				[_selector setAlpha:0.0];
			}
		}
		
		[_editView.scrollView setContentOffset:[_editView.scrollView contentOffset]];
		[_editView.scrollIndicator setIndicatorHeight:[selector indicatorHeight] relativeToHeight:400];
		[_editView.scrollIndicator setIndicatorPosition:[selector indicatorPosition]];
	} else {
		currentCustomizationSelector = nil;
	}
}

// Style
- (NSArray*)faceStyleViews {
	return nil;
}

- (void)setFaceStyle:(int)style {
	[watchFacePreferences setValue:[NSNumber numberWithInt:style] forKey:@"style"];
	NSMutableDictionary* preferencesContainer = [[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] mutableCopy];
	[preferencesContainer setObject:watchFacePreferences forKey:[_watchFaceBundle bundleIdentifier]];
	
	[[objc_getClass("LWPreferences") sharedInstance] setObject:preferencesContainer forKey:@"watchFacePreferences"];
}

- (int)faceStyle {
	return [[watchFacePreferences objectForKey:@"style"] intValue];
}

// Detail
- (NSArray*)faceDetailViews {
	return nil;
}

- (void)setFaceDetail:(int)detail {
	if (self.detailImages) {
		for (int i=0; i<[self.detailImages count]; i++) {
			for (UIImageView* image in [self.detailImages objectAtIndex:i]) {
				[image setAlpha: i == detail ? 1 : 0];
			}
		}
	}
	
	[watchFacePreferences setValue:[NSNumber numberWithInt:detail] forKey:@"detail"];
	NSMutableDictionary* preferencesContainer = [[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] mutableCopy];
	[preferencesContainer setObject:watchFacePreferences forKey:[_watchFaceBundle bundleIdentifier]];
	
	[[objc_getClass("LWPreferences") sharedInstance] setObject:preferencesContainer forKey:@"watchFacePreferences"];
}

- (int)faceDetail {
	return [[watchFacePreferences valueForKey:@"detail"] intValue];
}

// Accent Color
- (void)setAccentColor:(NSString*)color {
	[watchFacePreferences setObject:color forKey:@"accentColor"];
	NSMutableDictionary* preferencesContainer = [[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] mutableCopy];
	[preferencesContainer setObject:watchFacePreferences forKey:[_watchFaceBundle bundleIdentifier]];
	
	[[objc_getClass("LWPreferences") sharedInstance] setObject:preferencesContainer forKey:@"watchFacePreferences"];
}

- (NSString*)accentColor {
	return [watchFacePreferences objectForKey:@"accentColor"];
}

// Complications
- (void)setComplicationIndex:(int)index forPosition:(NSString*)position {
	NSMutableDictionary* settings = [[watchFacePreferences objectForKey:@"complications"] mutableCopy];
	
	if (!settings) {
		settings = [NSMutableDictionary new];
	}
	
	[settings setValue:[NSNumber numberWithInt:index] forKey:position];
	[watchFacePreferences setObject:settings forKey:@"complications"];
	NSMutableDictionary* preferencesContainer = [[[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchFacePreferences"] mutableCopy];
	[preferencesContainer setObject:watchFacePreferences forKey:[_watchFaceBundle bundleIdentifier]];
	
	[[objc_getClass("LWPreferences") sharedInstance] setObject:preferencesContainer forKey:@"watchFacePreferences"];
}

- (int)complicationIndexForPosition:(NSString*)position {
	return -1;
}

@end
