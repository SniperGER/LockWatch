#import "LWKActivityDataProvider.h"

@implementation LWKActivityDataProvider

+ (NSDictionary*)activityData {
	NSMutableDictionary* activityData = [NSMutableDictionary new];
	NSString* path = @"/var/mobile/Library/Health/healthdb_secure.sqlite";
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		sqlite3* activity;
		
		if (sqlite3_open([path UTF8String], &activity) == SQLITE_OK) {
			sqlite3_stmt* statement;
			const char* query = [@"SELECT energy_burned, brisk_minutes, active_hours, energy_burned_goal, brisk_minutes_goal, active_hours_goal FROM activity_caches ORDER BY data_id DESC LIMIT 1" UTF8String];
			
			if (sqlite3_prepare_v2(activity, query, -1, &statement, NULL) == SQLITE_OK) {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					for (int i=0; i<6; i++) {
						NSString* key = [NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, i)];
						NSString* value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
						[activityData setValue:value forKey:key];
					}
				}
			}
		}
	}
	
	return [activityData copy];
}

@end
