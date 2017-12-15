#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@class LWKClockBase;

@interface LWKPageView : UIView {
	UILabel* titleLabel;
	UIView* backgroundView;
}

@property (nonatomic,strong) LWKClockBase* watchFace;

- (void)setBackgroundAlpha:(CGFloat)alpha;

@end
