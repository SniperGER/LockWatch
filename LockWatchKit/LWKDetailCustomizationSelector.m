#import "LWKDetailCustomizationSelector.h"
#import "LWKClockBase.h"
#import "LWKFaceEditView.h"
#import "LWKScrollIndicator.h"

@implementation LWKDetailCustomizationSelector

- (id)initWithFrame:(CGRect)frame options:(NSDictionary *)options forWatchFace:(LWKClockBase *)watchFace faceEditView:(LWKFaceEditView *)faceEditView {
	if (self = [super initWithFrame:frame options:options forWatchFace:watchFace faceEditView:faceEditView]) {
		[contentScrollView setDelegate:nil];
		[contentScrollView setContentOffset:CGPointMake(0, watchFace.faceDetail * 400)];
		[contentScrollView setDelegate:self];
	}
	
	return self;
}

- (NSString*)type {
	return @"detail";
}

- (CGFloat)indicatorHeight {
	return [customizingOptions[@"options"] count] * 400;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat height = 400;
	CGFloat currentPage = MAX(MIN(ceilf(scrollView.contentOffset.y / scrollView.bounds.size.height), customizingWatchFace.detailImages.count - 1), 0);
	
	CGFloat pageProgress = ((currentPage * height) - scrollView.contentOffset.y) / height;
	pageProgress = (round(pageProgress * 100)) / 100.0;
	
	int prevIndex = (currentPage > 0) ? floor(currentPage) : 0;
	int nextIndex = (currentPage < customizingWatchFace.detailImages.count - 1) ? ceil(currentPage) : (int)customizingWatchFace.detailImages.count - 1;
	
	if (lastScrollY != scrollView.contentOffset.y && scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + height < scrollView.contentSize.height) {
		for (int i=0; i<customizingWatchFace.detailImages.count; i++) {
			for (UIImageView* detailImage in customizingWatchFace.detailImages[i]) {
				[detailImage setAlpha:0.0];
			}
		}
		
		if (lastScrollY < scrollView.contentOffset.y) {
			NSArray* next = [customizingWatchFace.detailImages objectAtIndex:nextIndex];
			
			if (scrollView.contentOffset.y + height <= scrollView.contentSize.height && scrollView.contentOffset.y > 0) {
				NSArray* current = [customizingWatchFace.detailImages objectAtIndex:MAX(nextIndex-1, 0)];
				
				for (UIImageView* image in current) {
					[image setAlpha:MAX(0, pageProgress)];
				}
				for (UIImageView* image in next) {
					[image setAlpha:MAX(0, 1-pageProgress)];
				}
			}
		}
		
		if (lastScrollY > scrollView.contentOffset.y) {
			NSArray* prev = [customizingWatchFace.detailImages objectAtIndex:prevIndex];
			
			if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y + height <= scrollView.contentSize.height) {
				NSArray* current = [customizingWatchFace.detailImages objectAtIndex:MIN(prevIndex-1, [customizingOptions[@"options"] count] - 1)];
				
				for (UIImageView* image in current) {
					[image setAlpha:MAX(0, pageProgress)];
				}
				for (UIImageView* image in prev) {
					[image setAlpha:MAX(0, 1-pageProgress)];
				}
			}
		}
	}
	
	lastScrollY = scrollView.contentOffset.y;
	[[customizingFaceEditView scrollIndicator] setIndicatorPosition:[self indicatorPosition]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat currentPage = MAX(MIN(ceilf(scrollView.contentOffset.y / scrollView.bounds.size.height), customizingWatchFace.faceStyleViews.count - 1), 0);
	
	[customizingWatchFace setFaceDetail:currentPage];
}

@end
