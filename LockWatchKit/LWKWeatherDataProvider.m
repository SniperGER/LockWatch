#import "LWKWeatherDataProvider.h"
#import "Weather.h"
#import <objc/runtime.h>

static WeatherPreferences* weatherPreferences;

@implementation LWKWeatherDataProvider

+ (City*)currentCity {
	if (!weatherPreferences) {
		weatherPreferences = [objc_getClass("WeatherPreferences") sharedPreferences];
	}
	
	City* currentCity;
	
	if ([weatherPreferences isLocalWeatherEnabled]) {
		currentCity = [weatherPreferences localWeatherCity];
	} else {
		if ([weatherPreferences loadSavedCities] && [weatherPreferences loadSavedCities].count > 0) {
			currentCity = [weatherPreferences loadSavedCities][0];
		}
	}
	
	if (!currentCity) {
		if ([weatherPreferences _defaultCities] && [weatherPreferences _defaultCities].count > 0) {
			currentCity = [weatherPreferences _defaultCities][0];
		}
	}
	
	return currentCity;
}

+ (double)currentTemperatureForCity:(City*)city {
	if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
		
	} else {
		return [city.temperature temperatureForUnit:[weatherPreferences userTemperatureUnit]];
	}
	
	return 0;
}

+ (NSArray*)hourlyConditionsForCity:(City*)city {
	NSMutableArray* conditionCodes = [NSMutableArray new];
	NSArray* forecasts = [city hourlyForecasts];
	
	for (int i=0; i<forecasts.count; i++) {
		WAHourlyForecast* forecast = [forecasts objectAtIndex:i];
		[conditionCodes addObject:[NSNumber numberWithInteger:[forecast conditionCode]]];
	}
	
	return conditionCodes;
}

@end
