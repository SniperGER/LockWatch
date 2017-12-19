#import "LockWatchKit.h"

@implementation LWKClockBase

- (id)init {
	if (self = [super init]) {
		watchFacePreferences = [NSMutableDictionary new];
		
		_clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		
		[_clockView addSubview:_backgroundView];
		[_clockView addSubview:_contentView];
		
		_watchFaceBundle = [NSBundle bundleForClass:self.class];
		
		[self prepareCustomizationMode];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	
}

- (void)prepareForInit {
	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

- (void)prepareCustomizationMode {
	NSArray* customizationOptions = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"Customization" ofType:@"plist"]];
	
	if (customizationOptions) {
		//_isCustomizable = YES;
	}
}

- (void)setIsEditing:(BOOL)isEditing {
	_isEditing = isEditing;
	
	/*[_editView setHidden:!isEditing];
	
	if (isEditing) {
		if ([self focussedViewsForEditingPage:[_editView currentPage]]) {
			NSArray* viewsToKeep = [self focussedViewsForEditingPage:[_editView currentPage]];
			
			for (UIView* subview in _contentView.subviews) {
				if (![viewsToKeep containsObject:subview]) {
					[subview setAlpha:0];
				}
			}
		}
	} else {
		for (UIView* subview in _contentView.subviews) {
			[subview setAlpha:1];
		}
	}*/
}

- (void)didStartUpdatingTime {}
- (void)didStopUpdatingTime {}

- (void)setAccentColor:(UIColor*)color {}

- (NSArray*)focussedViewsForEditingPage:(int)page {
	return nil;
}
- (NSArray*)hiddenViewsForEditingPage:(int)page {
	return nil;
}

@end
