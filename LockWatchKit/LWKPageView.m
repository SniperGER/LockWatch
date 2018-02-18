#import "LockWatchKit.h"

@interface LWPreferences : NSObject

+ (id)sharedInstance;
- (id)objectForKey:(id)arg1;

@end


@implementation LWKPageView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		NSString* sizeClass = [[objc_getClass("LWPreferences") sharedInstance] objectForKey:@"watchSize"];
		CGRect backgroundFrame = CGRectZero;
		
		if ([sizeClass isEqualToString:@"regular"]) {
			backgroundFrame = CGRectMake(-16, -16, frame.size.width + 32, frame.size.height + 32);
		} else if ([sizeClass isEqualToString:@"compact"]) {
			backgroundFrame = CGRectMake(-26, -26, frame.size.width + 52, frame.size.height + 52);
		}
		
		if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 9
		} else if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_10_3) {
			// iOS 10 - 10.2
			
			backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
			[backgroundView setFrame:backgroundFrame];

			if ([backgroundView respondsToSelector:@selector(setCornerRadius:)]) {
				[(NCMaterialView*)backgroundView setCornerRadius:15.0];
			} else {
				[backgroundView.layer setCornerRadius:15.0];
				[backgroundView setClipsToBounds:YES];
			}
			
			[self addSubview:backgroundView];
		} else if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_11_0) {
			// iOS 10.3
			backgroundView = [objc_getClass("MTMaterialView") materialViewWithStyleOptions:2];
			[backgroundView setFrame:backgroundFrame];
			[(NCMaterialView*)backgroundView setCornerRadius:15.0];
			[self addSubview:backgroundView];
		} else {
			// iOS 11
			backgroundView = [objc_getClass("MTMaterialView") materialViewWithRecipe:4 options:2];
			[backgroundView setFrame:backgroundFrame];
			[backgroundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.44]];
			[backgroundView.layer setCornerRadius:15.0];
			[backgroundView setClipsToBounds:YES];
			[self addSubview:backgroundView];
		}
		
		[backgroundView setAlpha:0.0];
	}
	
	return self;
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
	[backgroundView setAlpha:alpha];
}

@end
