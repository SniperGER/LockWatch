#import <UIKit/UIKit.h>

@interface LWKScrollIndicator : UIView {
	UIView* innerView;
	double indicatorScale;
	double indicatorHeight;
}

- (void)setIndicatorHeight:(CGFloat)height relativeToHeight:(CGFloat)relativeHeight;
- (void)setIndicatorPosition:(CGFloat)percentage;

@end
