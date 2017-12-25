#import <UIKit/UIKit.h>

@interface LWMetrics : NSObject

typedef NS_ENUM(NSUInteger, LWWatchSizeMode) {
	LWWatchSizeModeRegular,
	LWWatchSizeModeCompact,
	LWWatchSizeModeOptimized,
};

+ (LWWatchSizeMode)watchSizeMode;
+ (CGSize)watchSize;
+ (CGFloat)facePageSpacing;

@end
