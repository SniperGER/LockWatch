#import "LWKColorCustomizationSelector.h"
#import "LWKClockBase.h"
#import "LWKAnalogClock.h"
#import "LWKFaceEditView.h"
#import "LWKScrollIndicator.h"
#import "LWKLabel.h"
#import "WatchColors.h"

#define kCellHeight 60

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
		
		[contentScrollView setDelegate:nil];
		[contentScrollView setContentOffset:CGPointMake(0, (int)[WatchColors.colorNames indexOfObject:watchFace.accentColor]*kCellHeight)];
		[contentScrollView setDelegate:self];
		
		NSString* localizedColorName = [[[NSBundle bundleForClass:self.class] localizedStringForKey:watchFace.accentColor value:@"" table:nil] uppercaseString];
		[labelView setText:localizedColorName];
		if (options[@"label"][@"align"]) {
			CGRect labelFrame = labelView.frame;
			if ([options[@"label"][@"align"] isEqualToString:@"left"]) {
				labelFrame.origin.x = 0;
			} else if ([options[@"label"][@"align"] isEqualToString:@"right"]) {
				labelFrame.origin.x = self.bounds.size.width - labelFrame.size.width;
			}
			[labelView setFrame:labelFrame];
		}
	}
	
	return self;
}

- (CGFloat)indicatorHeight {
	return (([WatchColors colorNames].count * kCellHeight) + (400 - kCellHeight));
}

- (void)handleSwipeRightToLeft:(CGFloat)scrollProgress isNext:(BOOL)next {
	[super handleSwipeRightToLeft:scrollProgress isNext:next];
	
	if (next) {
		for (UIView* view in customizingWatchFace.backgroundView.subviews) {
			if (![view isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
				[view setAlpha:scrollProgress];
			}
		}
		
		[customizingWatchFace.contentView setAlpha:MAX(1 - scrollProgress, 0.15)];
		[customizingWatchFace.indicatorView setAlpha:scrollProgress];
		
		if ([(LWKAnalogClock*)customizingWatchFace hourHand]) {
			[[(LWKAnalogClock*)customizingWatchFace hourHand] setAlpha:0.25];
		}
		
		if ([(LWKAnalogClock*)customizingWatchFace minuteHand]) {
			[[(LWKAnalogClock*)customizingWatchFace minuteHand] setAlpha:0.25];
		}
		
		if ([(LWKAnalogClock*)customizingWatchFace secondHand]) {
			[[(LWKAnalogClock*)customizingWatchFace secondHand] setAlpha:1.0];
		}
	} else {
		//[customizingWatchFace.backgroundView setAlpha:1 - scrollProgress];
	}
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
		NSString* localizedColorName = [[[NSBundle bundleForClass:self.class] localizedStringForKey:[[WatchColors colorNames] objectAtIndex:page] value:@"" table:nil] uppercaseString];
		[labelView setText:localizedColorName];
		if (customizingOptions[@"label"][@"align"]) {
			CGRect labelFrame = labelView.frame;
			if ([customizingOptions[@"label"][@"align"] isEqualToString:@"left"]) {
				labelFrame.origin.x = 0;
			} else if ([customizingOptions[@"label"][@"align"] isEqualToString:@"right"]) {
				labelFrame.origin.x = self.bounds.size.width - labelFrame.size.width;
			}
			[labelView setFrame:labelFrame];
		}
		
		[customizingWatchFace setAccentColor:[[WatchColors colorNames] objectAtIndex:page]];
	}
	
	[[customizingFaceEditView scrollIndicator] setIndicatorPosition:[self indicatorPosition]];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	
	CGFloat kMaxIndex = 39;
	CGFloat targetY = scrollView.contentOffset.y + velocity.x * 60.0;
	CGFloat targetIndex = round(targetY / (kCellHeight));
	if (targetIndex < 0)
		targetIndex = 0;
	if (targetIndex > kMaxIndex)
		targetIndex = kMaxIndex;
	targetContentOffset->y = targetIndex * (kCellHeight);
}

@end
