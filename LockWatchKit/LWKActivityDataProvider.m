#import "LWKActivityDataProvider.h"

@implementation LWKActivityDataProvider

+ (NSDictionary*)activityData {
	NSMutableDictionary* activityData = [NSMutableDictionary new];
	NSString* path = @"/var/mobile/Library/Health/healthdb_secure.sqlite";
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		sqlite3* activity;
		
		if (sqlite3_open([path UTF8String], &activity) == SQLITE_OK) {
			sqlite3_stmt* statement;
			NSString* query = @"SELECT * FROM key_value_secure WHERE key =  'LatestCalorieBurnGoalMetCalories' OR key = 'CaloriesBurnedToday' OR key = 'BriskMinutesToday' OR key = 'StandingHoursToday'";
			
			if (sqlite3_prepare_v2(activity, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSString* key = ((char*)sqlite3_column_text(statement, 4)) ? [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)] : nil;
					NSString* value = ((char*)sqlite3_column_text(statement, 5)) ? [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)] : nil;
					
					[activityData setValue:value forKey:key];
				}
			}
		}
	}
	
	return [activityData copy];
}

@end
