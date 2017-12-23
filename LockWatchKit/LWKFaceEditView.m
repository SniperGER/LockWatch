#import "LockWatchKit.h"
#import "LWKStyleCustomizationSelector.h"
#import "LWKColorCustomizationSelector.h"

@implementation LWKFaceEditView

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWKClockBase*)watchFace {
	if (self = [super initWithFrame:frame]) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		[_scrollView setPagingEnabled:YES];
		[_scrollView setShowsHorizontalScrollIndicator:NO];
		[_scrollView setShowsVerticalScrollIndicator:NO];
		[_scrollView setDelegate:self];
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
	CGFloat offset = scrollView.contentOffset.x;
	CGFloat page = MAX(MIN(ceilf(scrollView.contentOffset.x / 312), pages.count - 1), 0);
	
	CGFloat pageProgress = (((page) * 312) - offset)/312;
	pageProgress = ABS((round(pageProgress*100))/100.0);
	
	int prevIndex = (page > 0) ? floor(page) : 0;
	int nextIndex = (page < pages.count - 1) ? ceil(page) : (int)pages.count - 1;
	
	if (lastScrollX != scrollView.contentOffset.x ) {
		if (lastScrollX < scrollView.contentOffset.x) {
			LWKCustomizationSelector* next = [pages objectAtIndex:nextIndex];
			
			if (scrollView.contentOffset.x + 312 < scrollView.contentSize.width && scrollView.contentOffset.x > 0) {
				LWKCustomizationSelector* current = [pages objectAtIndex:MAX(nextIndex - 1, 0)];
				
				[current handleSwipeRightToLeft:pageProgress isNext:NO];
				[next handleSwipeRightToLeft:1-pageProgress isNext:YES];
				
				CGFloat scrollIndicatorHeightDelta = [current indicatorHeight] - [next indicatorHeight];
				CGFloat scrollIndicatorPositionDelta = [current indicatorPosition] - [next indicatorPosition];
				
				[_scrollIndicator setIndicatorHeight:[current indicatorHeight] - (scrollIndicatorHeightDelta * (1 - pageProgress)) relativeToHeight:400];
				[_scrollIndicator setIndicatorPosition:[current indicatorPosition] - scrollIndicatorPositionDelta * (1 - pageProgress)];
			}
		}
		
		if (lastScrollX > scrollView.contentOffset.x) {
			LWKCustomizationSelector* prev = [pages objectAtIndex:prevIndex];
			if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x + 312 < scrollView.contentSize.width) {
				
				LWKCustomizationSelector* current = [pages objectAtIndex:MIN(prevIndex - 1, pages.count - 1)];
				
				[current handleSwipeLeftToRight:pageProgress isPrev:YES];
				[prev handleSwipeLeftToRight:1-pageProgress isPrev:NO];
				
				CGFloat scrollIndicatorHeightDifference = [current indicatorHeight] - [prev indicatorHeight];
				CGFloat scrollIndicatorPositionDelta = [current indicatorPosition] - [prev indicatorPosition];
				
				[_scrollIndicator setIndicatorHeight:[current indicatorHeight] - (scrollIndicatorHeightDifference * (1 - pageProgress)) relativeToHeight:400];
				[_scrollIndicator setIndicatorPosition:[current indicatorPosition] - scrollIndicatorPositionDelta * (1 - pageProgress)];
			}
		}
	}
	
	lastScrollX = scrollView.contentOffset.x;
}

@end
