#import "LockWatch.h"

@implementation LWFaceLibraryOverlayView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setClipsToBounds:NO];
		
		titles = [NSMutableArray new];
		titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 46)];
		[titleView setClipsToBounds:NO];
		[titleView setUserInteractionEnabled:NO];
		[self addSubview:titleView];
		
		_customizeButton = [[LWFaceLibraryCustomizeButton alloc] initWithFrame:CGRectMake(54, 334, 204, 56)];
		[self addSubview:_customizeButton];
	}
	
	return self;
}

- (void)addTitle:(NSString *)title {
	UILabel* watchFaceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titles.count*230, 0, 312, 46)];
	[watchFaceTitleLabel setFont:[UIFont fontWithName:@".SFCompactText-Regular" size:26]];
	[watchFaceTitleLabel setTextAlignment:NSTextAlignmentCenter];
	[watchFaceTitleLabel setTextColor:[UIColor whiteColor]];
	[watchFaceTitleLabel setText:title];
	[titleView addSubview:watchFaceTitleLabel];
	
	[titles addObject:watchFaceTitleLabel];
}

- (void)setTitleAlpha:(CGFloat)alpha atIndex:(NSInteger)index {
	if (![titles objectAtIndex:index]) {
		return;
	}
	
	[[titles objectAtIndex:index] setAlpha:alpha];
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
