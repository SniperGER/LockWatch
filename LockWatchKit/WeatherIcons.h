#import <Foundation/Foundation.h>

@interface WeatherIcons : NSObject

+ (NSString*)imageForConditionCode:(NSInteger)code atHour:(NSInteger)hour;

@end
