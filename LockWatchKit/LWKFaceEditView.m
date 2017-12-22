#import "LockWatchKit.h"
#import "LWKStyleCustomizationSelector.h"

@implementation LWKFaceEditView

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWKClockBase*)watchFace {
	if (self = [super initWithFrame:frame]) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, options.count * 312, 390)];
		[self addSubview:_scrollView];
		
		pages = [NSMutableArray new];
		
		for (int i=0; i<options.count; i++) {
			NSDictionary* customizingMode = [options objectAtIndex:i];
			
			if ([customizingMode[@"type"] isEqualToString:@"style"]) {
				LWKStyleCustomizationSelector* styleSelector = [[LWKStyleCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:styleSelector];
				[pages addObject:styleSelector];
			}
		}
		
		_scrollIndicator = [[LWKScrollIndicator alloc] initWithFrame:CGRectMake(296, 50, 12, 75)];
		[self addSubview:_scrollIndicator];
	}
	
	return self;
}

- (NSArray*)pages {
	return pages;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
	
}

@end
