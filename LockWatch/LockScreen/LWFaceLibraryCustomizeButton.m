#import "LockWatch.h"

@implementation LWFaceLibraryCustomizeButton

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self.titleLabel setFont:[UIFont fontWithName:@".SFCompactText-Regular" size:32]];
		[self setTitle:@"Customize" forState:UIControlStateNormal];
		
		if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 9
		} else if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_10_3) {
			// iOS 10 - 10.2
			
			backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
			[backgroundView setFrame:self.bounds];
			[(NCMaterialView*)backgroundView setCornerRadius:7.5];
			[self insertSubview:backgroundView atIndex:0];
			[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			
			CAFilter* filter = [CAFilter filterWithName:@"vibrantLight"];
			[self.titleLabel.layer setFilters:@[filter]];
		} else if (kCFCoreFoundationVersionNumber == kCFCoreFoundationVersionNumber_iOS_10_3) {
			// iOS 10.3
		} else {
			// iOS 11
			backgroundView = [objc_getClass("MTMaterialView") materialViewWithRecipe:4 options:2];
			[backgroundView setFrame:self.bounds];
			[backgroundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.44]];
			[(MTMaterialView*)backgroundView _setCornerRadius:7.5];
			[self insertSubview:backgroundView atIndex:0];
			[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		}
	}
	
	return self;
}

@end
