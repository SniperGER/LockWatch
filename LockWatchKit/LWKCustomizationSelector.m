#import "LWKCustomizationSelector.h"
#import "LWKFaceEditView.h"
#import "LWKLabel.h"

@implementation LWKCustomizationSelector

- (id)initWithFrame:(CGRect)frame options:(NSDictionary*)options forWatchFace:(LWKClockBase*)watchFace faceEditView:(LWKFaceEditView*)faceEditView {
	if (self = [super initWithFrame:frame]) {
		customizingOptions = options;
		customizingWatchFace = watchFace;
		customizingFaceEditView = faceEditView;
		
		if (options[@"frame"]) {
			borderView = [[UIView alloc] initWithFrame:CGRectFromString(options[@"frame"])];
			[borderView.layer setBorderWidth:2];
			[borderView.layer setBorderColor:[UIColor colorWithRed:0.02 green:0.87 blue:0.44 alpha:1.0].CGColor];
			
			if (options[@"cornerRadius"]) {
				[borderView.layer setCornerRadius:[options[@"cornerRadius"] floatValue]];
			}
			
			[self addSubview:borderView];
		}
		
		if (options[@"label"]) {
			labelView = [[LWKLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
			[labelView setText:[[[NSBundle bundleForClass:self.class] localizedStringForKey:options[@"label"][@"text"] value:@"" table:nil] uppercaseString]];
			[labelView setCenter:CGPointFromString(options[@"label"][@"center"])];
			[self addSubview:labelView];
			
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
		
		if (options[@"options"]) {
			contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 400)];
			[contentScrollView setContentSize:CGSizeMake(0, [options[@"options"] count] * 400)];
			[contentScrollView setDelegate:self];
			[contentScrollView setPagingEnabled:YES];
			[contentScrollView setShowsHorizontalScrollIndicator:NO];
			[contentScrollView setShowsVerticalScrollIndicator:NO];
			[self addSubview:contentScrollView];
		}
	}
	
	return self;
}

- (CGFloat)indicatorHeight {
	return 71;
}

- (CGFloat)indicatorPosition {
	return contentScrollView.contentOffset.y / (contentScrollView.contentSize.height - 400);
}

- (void)handleSwipeRightToLeft:(CGFloat)scrollProgress isNext:(BOOL)next {
	[self setAlpha:scrollProgress];
}

- (void)handleSwipeLeftToRight:(CGFloat)scrollProgress isPrev:(BOOL)prev {
	[self setAlpha:scrollProgress];
}

@end
