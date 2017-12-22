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
			[labelView setText:options[@"label"][@"text"]];
			[labelView setCenter:CGPointFromString(options[@"label"][@"center"])];
			[self addSubview:labelView];
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

@end
