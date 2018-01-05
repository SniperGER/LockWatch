#import "LWKStyleCustomizationSelector.h"
#import "LWKClockBase.h"
#import "LWKFaceEditView.h"
#import "LWKScrollIndicator.h"

@implementation LWKStyleCustomizationSelector

- (id)initWithFrame:(CGRect)frame options:(NSDictionary *)options forWatchFace:(LWKClockBase *)watchFace faceEditView:(LWKFaceEditView *)faceEditView {
	if (self = [super initWithFrame:frame options:options forWatchFace:watchFace faceEditView:faceEditView]) {
		
		[contentScrollView setDelegate:nil];
		[contentScrollView setContentOffset:CGPointMake(0, watchFace.faceStyle * 400)];
		[contentScrollView setDelegate:self];
	}
	
	return self;
}

- (NSString*)type {
	return @"style";
}

- (CGFloat)indicatorHeight {
	if (customizingWatchFace.faceStyleViews) {
		return customizingWatchFace.faceStyleViews.count * 400;
	}
	
	if (customizingOptions[@"options"]) {
		return [customizingOptions[@"options"] count] * 400;
	}
	
	return 400;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!customizingWatchFace.faceStyleViews) {
		CGFloat page = (scrollView.contentOffset.y / scrollView.bounds.size.height);
		CGFloat pageProgress = 1 + (page - (int)page - 1);
		
		if (pageProgress < 0.5) {
			page = floorf(page);
		} else {
			page = ceilf(page);
		}
		
		[customizingWatchFace setFaceStyle:page];
		
	} else {
		
		CGFloat height = 400;
		CGFloat currentPage = MAX(MIN(ceilf(scrollView.contentOffset.y / scrollView.bounds.size.height), customizingWatchFace.faceStyleViews.count - 1), 0);
		
		CGFloat pageProgress = ((currentPage * height) - scrollView.contentOffset.y) / height;
		pageProgress = (round(pageProgress * 100)) / 100.0;
		
		int prevIndex = (currentPage > 0) ? floor(currentPage) : 0;
		int nextIndex = (currentPage < customizingWatchFace.faceStyleViews.count - 1) ? ceil(currentPage) : (int)customizingWatchFace.faceStyleViews.count - 1;
		
		if (lastScrollY != scrollView.contentOffset.y && scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + height < scrollView.contentSize.height) {
			for (UIView* view in customizingWatchFace.faceStyleViews) {
				[view setAlpha:0];
			}
			
			if (lastScrollY < scrollView.contentOffset.y) {
				UIView* next = [customizingWatchFace.faceStyleViews objectAtIndex:nextIndex];
				
				if (scrollView.contentOffset.y + height <= scrollView.contentSize.height && scrollView.contentOffset.y > 0) {
					UIView* current = [customizingWatchFace.faceStyleViews objectAtIndex:MAX(nextIndex-1, 0)];
					
					[current setAlpha:MAX(0, pageProgress)];
					[next setAlpha:MAX(0, 1-pageProgress)];
				}
			}
			
			if (lastScrollY > scrollView.contentOffset.y) {
				UIView* prev = [customizingWatchFace.faceStyleViews objectAtIndex:prevIndex];
				
				if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y + height <= scrollView.contentSize.height) {
					UIView* current = [customizingWatchFace.faceStyleViews objectAtIndex:MIN(prevIndex-1, customizingWatchFace.faceStyleViews.count- 1)];
					
					[current setAlpha:MAX(0, pageProgress)];
					[prev setAlpha:MAX(0, 1-pageProgress)];
				}
			}
		}
	}
	
	lastScrollY = scrollView.contentOffset.y;
	[[customizingFaceEditView scrollIndicator] setIndicatorPosition:[self indicatorPosition]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat currentPage = MAX(MIN(ceilf(scrollView.contentOffset.y / scrollView.bounds.size.height), customizingWatchFace.faceStyleViews.count - 1), 0);
	
	[customizingWatchFace setFaceStyle:currentPage];
}

@end
