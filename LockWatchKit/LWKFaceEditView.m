#import "LockWatchKit.h"
#import "LWKStyleCustomizationSelector.h"
#import "LWKColorCustomizationSelector.h"

@implementation LWKFaceEditView

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWKClockBase*)watchFace {
	if (self = [super initWithFrame:frame]) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		[self addSubview:_scrollView];
		
		pages = [NSMutableArray new];
		
		for (int i=0; i<options.count; i++) {
			NSDictionary* customizingMode = [options objectAtIndex:i];
			
			if ([customizingMode[@"type"] isEqualToString:@"style"]) {
				LWKStyleCustomizationSelector* styleSelector = [[LWKStyleCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:styleSelector];
				[pages addObject:styleSelector];
			}
			
			if ([customizingMode[@"type"] isEqualToString:@"detail"]) {}
			
			if ([customizingMode[@"type"] isEqualToString:@"color"]) {
				LWKColorCustomizationSelector* colorSelector = [[LWKColorCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:colorSelector];
				[pages addObject:colorSelector];
			}
		}
		
		[_scrollView setContentSize:CGSizeMake(options.count * 312, 390)];
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
