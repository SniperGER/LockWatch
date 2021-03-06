#import "LockWatchKit.h"
#import "LWKStyleCustomizationSelector.h"
#import "LWKDetailCustomizationSelector.h"
#import "LWKColorCustomizationSelector.h"
#import "LWKComplicationCustomizationSelector.h"

@implementation LWKFaceEditView

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWKClockBase*)watchFace {
	if (self = [super initWithFrame:frame]) {
		customizingWatchFace = watchFace;
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		[_scrollView setPagingEnabled:YES];
		[_scrollView setShowsHorizontalScrollIndicator:NO];
		[_scrollView setShowsVerticalScrollIndicator:NO];
		[_scrollView setDelegate:self];
		[_scrollView setClipsToBounds:NO];
		[self addSubview:_scrollView];
		
		pages = [NSMutableArray new];
		
		for (int i=0; i<options.count; i++) {
			NSDictionary* customizingMode = [options objectAtIndex:i];
			
			if ([customizingMode[@"type"] isEqualToString:@"style"]) {
				LWKStyleCustomizationSelector* styleSelector = [[LWKStyleCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:styleSelector];
				[pages addObject:styleSelector];
			}
			
			if ([customizingMode[@"type"] isEqualToString:@"detail"]) {
				watchFace.detailImages = [NSMutableArray new];
				NSArray* options = [customizingMode objectForKey:@"options"];
				
				for (int j=0; j<options.count; j++) {
					NSMutableArray* images = [[NSMutableArray alloc] init];
					
					for (int k=0; k<[options[j] count]; k++) {
						UIImageView* detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:options[j][k] inBundle:watchFace.watchFaceBundle compatibleWithTraitCollection:nil]];
						[detailImage setFrame:CGRectMake(0, 0, 312, 312)];
						[detailImage setCenter:CGPointMake(156, 195)];
						
						if (j != watchFace.faceDetail) {
							[detailImage setAlpha:0];
						}
						
						[watchFace.contentView addSubview:detailImage];
						[images addObject:detailImage];
					}
					
					[watchFace.detailImages addObject:images];
				}
				
				LWKDetailCustomizationSelector* detailSelector = [[LWKDetailCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:detailSelector];
				[pages addObject:detailSelector];
			}
			
			if ([customizingMode[@"type"] isEqualToString:@"color"]) {
				LWKColorCustomizationSelector* colorSelector = [[LWKColorCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:colorSelector];
				[pages addObject:colorSelector];
			}
			
			if ([customizingMode[@"type"] isEqualToString:@"complications"]) {
				LWKComplicationCustomizationSelector* complicationSelector = [[LWKComplicationCustomizationSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:customizingMode forWatchFace:watchFace faceEditView:self];
				[_scrollView addSubview:complicationSelector];
				[pages addObject:complicationSelector];
			}
		}
		
		[_scrollView setContentSize:CGSizeMake(options.count * 312, 390)];
		_scrollIndicator = [[LWKScrollIndicator alloc] initWithFrame:CGRectMake(296, 50, 12, 75)];
		[self addSubview:_scrollIndicator];
		
		if (options.count > 1) {
			pageIndicator = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 46, 10)];
			[pageIndicator setCenter:CGPointMake(156, 5)];
			[pageIndicator setNumberOfPages:options.count];
			[pageIndicator setCurrentPage:0];
			[self addSubview:pageIndicator];
		}
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
	
	if (lastScrollX != scrollView.contentOffset.x) {
		if (lastScrollX < scrollView.contentOffset.x) {
			LWKCustomizationSelector* next = [pages objectAtIndex:nextIndex];
			
			if (scrollView.contentOffset.x + 312 < scrollView.contentSize.width && scrollView.contentOffset.x > 0) {
				LWKCustomizationSelector* current = [pages objectAtIndex:MAX(nextIndex - 1, 0)];
				
				[current handleSwipeRightToLeft:pageProgress isNext:NO];
				[next handleSwipeRightToLeft:1-pageProgress isNext:YES];
				[(LWKClockBase<LWKCustomizationDelegate>*)customizingWatchFace customizationSelector:current didScrollToLeftWithNextSelector:next scrollProgress:1-pageProgress];
				
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
				[(LWKClockBase<LWKCustomizationDelegate>*)customizingWatchFace customizationSelector:current didScrollToRightWithPreviousSelector:prev scrollProgress:pageProgress];
				
				CGFloat scrollIndicatorHeightDifference = [current indicatorHeight] - [prev indicatorHeight];
				CGFloat scrollIndicatorPositionDelta = [current indicatorPosition] - [prev indicatorPosition];
				
				[_scrollIndicator setIndicatorHeight:[current indicatorHeight] - (scrollIndicatorHeightDifference * (1 - pageProgress)) relativeToHeight:400];
				[_scrollIndicator setIndicatorPosition:[current indicatorPosition] - scrollIndicatorPositionDelta * (1 - pageProgress)];
			}
		}
	} else {
		LWKCustomizationSelector* current = [pages objectAtIndex:MIN(MAX(page,0), pages.count - 1)];
		[_scrollIndicator setIndicatorHeight:[current indicatorHeight] relativeToHeight:400];
		[_scrollIndicator setIndicatorPosition:[current indicatorPosition]];
	}
	
	if (pageIndicator) {
		CGFloat controlPage = (scrollView.contentOffset.x / scrollView.bounds.size.width);
		CGFloat controlPageProgress = 1 + (controlPage - (int)controlPage - 1);
		
		if (controlPageProgress < 0.5) {
			controlPage = floorf(controlPage);
		} else {
			controlPage = ceilf(controlPage);
		}
		[pageIndicator setCurrentPage:controlPage];
	}
	
	lastScrollX = scrollView.contentOffset.x;
}

@end
