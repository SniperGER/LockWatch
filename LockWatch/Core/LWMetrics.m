#import "LockWatch.h"

@implementation LWMetrics

+ (NSString*)sizeClass {
	return [[LWPreferences sharedInstance] objectForKey:@"watchSize"];
}

+ (CGSize)watchSize {
	NSString* sizeString = self.sizeClass;
	
	if ([sizeString isEqualToString:@"regular"]) {
		return CGSizeMake(312, 390);
	} else if ([sizeString isEqualToString:@"compact"]) {
		return CGSizeMake(272, 340);
	}
	
	return CGSizeZero;
}

+ (CGFloat)watchWidth {
	return self.watchSize.width;
}

+ (CGFloat)watchHeight {
	return self.watchSize.height;
}

+ (double)interfaceScale {
	return self.watchWidth / 312.0;
}

+ (double)facePageSpacing {
	return 35;
}

+ (double)contentScale {
	NSString* sizeString = self.sizeClass;
	
	if ([sizeString isEqualToString:@"regular"]) {
		return 188.0 / 312.0;
	} else if ([sizeString isEqualToString:@"compact"]) {
		return 164.0 / 272.0;
	}
	
	return 1;
}

+ (double)overlayScale {
	NSString* sizeString = self.sizeClass;
	
	if ([sizeString isEqualToString:@"regular"]) {
		return 364.0 / 220.0;
	} else if ([sizeString isEqualToString:@"compact"]) {
		return 324.0 / 196.0;
	}
	
	return 1;
}

+ (double)pressedScale {
	NSString* sizeString = self.sizeClass;
	
	if ([sizeString isEqualToString:@"regular"]) {
		return 172.0 / 312.0;
	} else if ([sizeString isEqualToString:@"compact"]) {
		return 148.0 / 272.0;
	}
	
	return 1;
}

@end
