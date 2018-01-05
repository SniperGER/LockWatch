#import <Foundation/Foundation.h>

@class LWKCustomizationSelector;

@protocol LWKCustomizationDelegate

@required
- (void)customizationSelector:(LWKCustomizationSelector*)selector didScrollToLeftWithNextSelector:(LWKCustomizationSelector*)nextSelector scrollProgress:(CGFloat)scrollProgress;
- (void)customizationSelector:(LWKCustomizationSelector*)selector didScrollToRightWithPreviousSelector:(LWKCustomizationSelector*)prevSelector scrollProgress:(CGFloat)scrollProgress;

@end
