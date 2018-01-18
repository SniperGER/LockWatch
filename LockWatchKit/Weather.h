#import <Foundation/Foundation.h>

@protocol CityUpdateObserver <NSObject>
@optional
- (void)cityDidStartWeatherUpdate:(id)arg1;
- (void)cityDidFinishWeatherUpdate:(id)arg1;
@end

@interface WFTemperature : NSObject
- (double)temperatureForUnit:(int)arg1;
@end

@interface WAHourlyForecast : NSObject
- (NSInteger)conditionCode;
- (WFTemperature*)temperature;
- (NSInteger)hourIndex;
@end

@interface City : NSObject
@property (nonatomic,retain) NSHashTable * cityUpdateObservers;
- (BOOL)update;
- (NSInteger)conditionCode;
- (WFTemperature*)temperature;
- (NSArray*)hourlyForecasts;
- (NSString*)name;
@end

@interface WeatherPreferences : NSObject
+ (id)sharedPreferences;
- (BOOL)isLocalWeatherEnabled;
- (City*)localWeatherCity;
- (NSArray*)loadSavedCities;
- (NSArray*)_defaultCities;
- (int)userTemperatureUnit;
@end
