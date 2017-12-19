#import "LWKActivityDataProvider.h"

@implementation LWKActivityDataProvider

+ (NSDictionary*)activityData {
	NSMutableDictionary* activityData = [NSMutableDictionary new];
	NSString* path = @"/opt/simject/FESTIVAL/healthdb_secure.sqlite";
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSLog(@"[LockWatchKit] activity data exists");
		
		sqlite3* activity;
		if (sqlite3_open([path UTF8String], &activity) == SQLITE_OK) {
			NSLog(@"[LockWatchKit] activity database opened");
			
			sqlite3_stmt* statement;
			const char* query = [@"SELECT energy_burned, brisk_minutes, active_hours, energy_burned_goal, brisk_minutes_goal, active_hours_goal FROM activity_caches ORDER BY data_id DESC LIMIT 1" UTF8String];
			
			if (sqlite3_prepare_v2(activity, query, -1, &statement, NULL) == SQLITE_OK) {
				NSLog(@"[LockWatchKit] successfully read activity data");
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					for (int i=0; i<6; i++) {
						NSString* key = [NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, i)];
						NSString* value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
						[activityData setValue:value forKey:key];
					}
				}
				
				NSLog(@"[LockWatchKit] %@", activityData);
			} else {
				NSLog(@"[LockWatchKit] failed to read activity data");
			}
		} else {
			NSLog(@"[LockWatchKit] failed to open activity database");
		}
	} else {
		NSLog(@"[LockWatchKit] activity data does not exist");
	}
	
	return [activityData copy];
}

@end
