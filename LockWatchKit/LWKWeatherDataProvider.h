#import <Foundation/Foundation.h>

@class City;

@interface LWKWeatherDataProvider : NSObject

+ (City*)currentCity;
+ (double)currentTemperatureForCity:(City*)city;
+ (NSArray*)hourlyConditionsForCity:(City*)city;

@end
