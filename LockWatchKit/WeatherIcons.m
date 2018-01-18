#import "WeatherIcons.h"

@implementation WeatherIcons

+ (NSString*)imageForConditionCode:(NSInteger)code atHour:(NSInteger)hour {
	//Hour = (Hour > 23) ? Hour - 24 : Hour;
	NSInteger lightHour = 7;
	NSInteger darkHour = 20;
	
	NSString* imageName = @"";
	switch (code) {
		case 0:
			imageName = @"tornado";
			break;
		case 1:
			imageName = @"tropical_storm";
			break;
		case 2:
			imageName = @"hurricane";
			break;
		case 3:
		case 4:
		case 37:
		case 38:
		case 47:
			imageName = (hour >= lightHour && hour < darkHour) ? @"severe_thunderstorm_day" : @"severe_thunderstorm_night";
			break;
		case 5:
		case 6:
		case 13:
		case 14:
		case 16:
		case 41:
			imageName = @"flurry";
			break;
		case 7:
		case 8:
			imageName = @"flurry_snow_shower";
			break;
		case 9:
			imageName = (hour >= lightHour && hour < darkHour) ? @"drizzle_day" : @"drizzle_night";
			break;
		case 10:
		case 25:
			imageName = @"ice";
			break;
		case 11:
		case 12:
		case 39:
		case 45:
			imageName = (hour >= lightHour && hour < darkHour) ? @"rain_day" : @"rain_night";
			break;
		case 15:
			imageName = @"blowingsnow";
			break;
		case 17:
		case 35:
			imageName = (hour >= lightHour && hour < darkHour) ? @"hail_day" : @"hail_night";
			break;
		case 18:
		case 42:
		case 46:
			imageName = (hour >= lightHour && hour < darkHour) ? @"sleet_day" : @"sleet_night";
			break;
		case 19:
			imageName = @"dust";
			break;
		case 20:
			imageName = (hour >= lightHour && hour < darkHour) ? @"fog_day" : @"fog_night";
			break;
		case 21:
			imageName = @"haze";
			break;
		case 22:
			imageName = @"smoke";
			break;
		case 23:
		case 24:
			imageName = @"breezy";
			break;
		case 26:
		case 27:
		case 28:
			imageName = (hour >= lightHour && hour < darkHour) ? @"mostly-cloudy_day" : @"mostly-cloudy_night";
			break;
		case 29:
		case 30:
			imageName = (hour >= lightHour && hour < darkHour) ? @"partly-cloudy-day" : @"partly-cloudy-night";
			break;
		case 31:
		case 32:
		case 33:
		case 34:
			imageName = (hour >= lightHour && hour < darkHour) ? @"mostly-sunny" : @"clear-night";
			break;
		case 36:
			imageName = @"hot";
			break;
		case 40:
			imageName = (hour >= lightHour && hour < darkHour) ? @"heavy-rain_day" : @"heavy-rain_night";
			break;
		case 43:
			imageName = (hour >= lightHour && hour < darkHour) ? @"blizzard_day" : @"blizzard_night";
			break;
		case 44:
			imageName = @"no-report";
			break;
		default: break;
	}
	return [NSString stringWithFormat:@"%@-nc_100x100_", imageName];
}

@end
