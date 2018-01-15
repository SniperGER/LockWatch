#import <UIKit/UIKit.h>

@interface LWMetrics : NSObject

+ (NSString*)sizeClass;
+ (CGSize)watchSize;
+ (CGFloat)watchWidth;
+ (CGFloat)watchHeight;
+ (double)interfaceScale;
+ (double)facePageSpacing;
+ (double)contentScale;
+ (double)overlayScale;
+ (double)pressedScale;

@end
