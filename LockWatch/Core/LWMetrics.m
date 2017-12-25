#import "LockWatch.h"

@implementation LWMetrics

+ (LWWatchSizeMode)watchSizeMode {
//	if ([[[LWPreferences sharedInstance] objectForKey:@"watchSize"] isEqualToString:@"regular"]) {
		return LWWatchSizeModeRegular;
//	} else if ([[[LWPreferences sharedInstance] objectForKey:@"watchSize"] isEqualToString:@"compact"]) {
//		return LWWatchSizeModeCompact;
//	} else if ([[[LWPreferences sharedInstance] objectForKey:@"watchSize"] isEqualToString:@"optimized"]) {
//		return LWWatchSizeModeOptimized;
//	}
//
//	return -1;
}

+ (CGSize)watchSize {
//	switch ([self watchSizeMode]) {
//		case LWWatchSizeModeRegular:
			return CGSizeMake(312, 390);
//			break;
//		case LWWatchSizeModeCompact:
//			return CGSizeMake(272, 340);
//			break;
//		case LWWatchSizeModeOptimized:
//			return CGSizeMake(screenWidth - 102, (screenWidth - 102) / 0.8);
//			break;
//		default:
//			return CGSizeZero;
//			break;
//	}
}

+ (CGFloat)facePageSpacing {
//	switch ([self watchSizeMode]) {
//		case LWWatchSizeModeRegular:
			return 35;
//			break;
//		case LWWatchSizeModeCompact:
//			return 30;
//			break;
//		case LWWatchSizeModeOptimized:
//			return (35/312) * [self watchSize].width;
//			break;
//		default:
//			return 0;
//			break;
//	}
}

@end
