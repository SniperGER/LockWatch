#import "LockWatch.h"

@implementation LWFaceLibraryOverlayView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setClipsToBounds:NO];
		
		titles = [NSMutableArray new];
		titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [LWMetrics watchWidth], 46)];
		[titleView setClipsToBounds:NO];
		[titleView setUserInteractionEnabled:NO];
		[self addSubview:titleView];
		
		if ([[LWMetrics sizeClass] isEqualToString:@"regular"]) {
			_customizeButton = [[LWFaceLibraryCustomizeButton alloc] initWithFrame:CGRectMake(54, 334, 204, 56)];
		} else if ([[LWMetrics sizeClass] isEqualToString:@"compact"]) {
			_customizeButton = [[LWFaceLibraryCustomizeButton alloc] initWithFrame:CGRectMake(38, 290, 196, 50)];
		}
		[self addSubview:_customizeButton];
	}
	
	return self;
}

- (void)addTitle:(NSString *)title {
	UILabel* watchFaceTitleLabel;
	
	if ([[LWMetrics sizeClass] isEqualToString:@"regular"]) {
		watchFaceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titles.count*230, 0, [LWMetrics watchWidth], 46)];
		[watchFaceTitleLabel setFont:[UIFont fontWithName:@".SFCompactText-Regular" size:26]];
	} else if ([[LWMetrics sizeClass] isEqualToString:@"compact"]) {
		watchFaceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titles.count*207, 0, [LWMetrics watchWidth], 35)];
		[watchFaceTitleLabel setFont:[UIFont fontWithName:@".SFCompactText-Regular" size:24]];
	}
	
	[watchFaceTitleLabel setTextAlignment:NSTextAlignmentCenter];
	[watchFaceTitleLabel setTextColor:[UIColor whiteColor]];
	[watchFaceTitleLabel setText:title];
	
	[titleView addSubview:watchFaceTitleLabel];
	
	[titles addObject:watchFaceTitleLabel];
	
	[titleView setContentSize:CGSizeMake(titles.count * ([[LWMetrics sizeClass] isEqualToString:@"regular"] ? 230 : 207), [LWMetrics watchHeight])];
}

- (void)setTitleAlpha:(CGFloat)alpha atIndex:(NSInteger)index {
	if (![titles objectAtIndex:index]) {
		return;
	}
	
	[[titles objectAtIndex:index] setAlpha:alpha];
}

- (void)resetTitles {
	titles = [NSMutableArray new];
	[[titleView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	[titleView setContentSize:CGSizeMake(0, [LWMetrics watchHeight])];
}

- (CGSize)contentSize {
	return titleView.contentSize;
}

- (void)setContentSize:(CGSize)contentSize {
	[titleView setContentSize:contentSize];
}

- (CGPoint)contentOffset {
	return titleView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[titleView setContentOffset:contentOffset];
}

@end

