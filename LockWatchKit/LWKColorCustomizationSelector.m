#import "LWKColorCustomizationSelector.h"
#import "LWKClockBase.h"
#import "LWKFaceEditView.h"
#import "LWKScrollIndicator.h"
#import "WatchColors.h"

#define kCellHeight 120

@implementation LWKColorCustomizationSelector

- (id)initWithFrame:(CGRect)frame options:(NSDictionary *)options forWatchFace:(LWKClockBase *)watchFace faceEditView:(LWKFaceEditView *)faceEditView {
	if (self = [super initWithFrame:frame options:options forWatchFace:watchFace faceEditView:faceEditView]) {
		contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 400)];
		[contentScrollView setContentSize:CGSizeMake(0, ([WatchColors colorNames].count * kCellHeight) + (400 - kCellHeight))];
		[contentScrollView setDelegate:self];
		[contentScrollView setPagingEnabled:NO];
		[contentScrollView setShowsHorizontalScrollIndicator:NO];
		[contentScrollView setShowsVerticalScrollIndicator:NO];
		[self addSubview:contentScrollView];
	}
	
	return self;
}

- (CGFloat)indicatorHeight {
	return (([WatchColors colorNames].count * kCellHeight) + (400 - kCellHeight));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat page = (scrollView.contentOffset.y / kCellHeight);
	CGFloat pageProgress = 1 + (page - (int)page - 1);
	
	if (pageProgress < 0.5) {
		page = floorf(page);
	} else {
		page = ceilf(page);
	}
	
	if (page >= 0 && page < [WatchColors colorNames].count) {
//		NSString* localizedColorName = [self->resourcesBundle localizedStringForKey:[self.options objectAtIndex:page] value:@"" table:nil];
//		[self->_detailLabel setText:localizedColorName];
//		[self->_detailLabel.layer setPosition:CGPointMake(156, 370)];
		
		[customizingWatchFace setAccentColor:[[WatchColors colorNames] objectAtIndex:page]];
		NSLog(@"[LockWatch] setAccentColor");
	}
	
	[[customizingFaceEditView scrollIndicator] setIndicatorPosition:[self indicatorPosition]];
}

@end
