#import "LockWatchKit.h"
#import "LWKCustomizationSelector.h"

@implementation LWKClockBase

- (id)init {
	if (self = [super init]) {
		_clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		
		[_clockView addSubview:_backgroundView];
		[_clockView addSubview:_contentView];
		
		_watchFaceBundle = [NSBundle bundleForClass:self.class];
		watchFacePreferences = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]]];
		
		if (!watchFacePreferences) {
			watchFacePreferences = [NSMutableDictionary new];
			[watchFacePreferences writeToFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]] atomically:YES];
		}
		
		[self prepareCustomizationMode];
	}
	
	return self;
}

- (void)prepareForInit {
	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {}
- (void)didStartUpdatingTime {}
- (void)didStopUpdatingTime {}

#pragma mark Customization

- (void)prepareCustomizationMode {
	customizationOptions = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"Customization" ofType:@"plist"]];
	
	if (customizationOptions) {
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
	[watchFacePreferences writeToFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]] atomically:YES];
}

// Detail
- (NSArray*)faceDetailViews {
	return nil;
}

- (void)setFaceDetail:(int)detail {}

// Accent Color
- (void)setAccentColor:(NSString*)color {
	[watchFacePreferences setObject:color forKey:@"accentColor"];
	[watchFacePreferences writeToFile:[NSString stringWithFormat:FACE_PREFERENCES_PATH, [_watchFaceBundle bundleIdentifier]] atomically:YES];}

@end
