#import "LockWatchKit.h"

@implementation LWKPageView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {		
		if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 9
		} else if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_10_3) {
			// iOS 10 - 10.2
			
			backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
			[backgroundView setFrame:CGRectMake(-16, -16, frame.size.width + 32, frame.size.height + 32)];
			[(NCMaterialView*)backgroundView setCornerRadius:15.0];
			[self addSubview:backgroundView];
		} else {
			// iOS 10.3
		}
		
		[backgroundView setAlpha:0.0];
	}
	
	return self;
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
	[backgroundView setAlpha:alpha];
}

@end
