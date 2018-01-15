#import "LockWatch.h"

@implementation LWPreferences

static LWPreferences* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

+ (id)defaults {
	return @{
			 @"enabled": @YES,
			 @"watchFaceOrder": @[
					 @"ml.festival.ActivityAnalog",
					 @"ml.festival.ActivityDigital",
					 @"ml.festival.Numerals",
					 @"ml.festival.Utility",
					 @"ml.festival.Simple",
					 @"ml.festival.Color",
					 @"ml.festival.Chronograph",
					 @"ml.festival.XLarge",
					 @"ml.festival.Weather"
					 ],
			 @"disabledWatchFaces": @[],
			 @"watchSize": @"regular",
			 @"watchFacePreferences": [@{} mutableCopy]
			 };
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		
#if APP_CONTEXT
		preferences = [NSUserDefaults standardUserDefaults];
		
		for (id key in self.class.defaults) {
			if (![preferences objectForKey:key]) {
				[preferences setObject:[self.class.defaults objectForKey:key] forKey:key];
			}
		}
#endif
/*#if (TARGET_OS_SIMULATOR || APP_CONTEXT)
		preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
		
		if (!preferences) {
			preferences = [NSMutableDictionary new];
		}
		
		// Main switch
		if (![preferences objectForKey:@"enabled"]) {
			[preferences setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
		}
		
		// Simulated watch size
		if (![preferences objectForKey:@"watchSize"]) {
			// regular, compact, optimized
			[preferences setObject:@"regular" forKey:@"watchSize"];
		}
		
		// Always minimized
		if (![preferences objectForKey:@"alwaysMinimized"]) {
			[preferences setValue:[NSNumber numberWithBool:NO] forKey:@"alwaysMinimized"];
		}
		
		// Y offset from center
		if (![preferences objectForKey:@"yOffset"]) {
			[preferences setValue:[NSNumber numberWithFloat:0.0] forKey:@"yOffset"];
		}
		
		// Watch Face order
		if (![preferences objectForKey:@"watchFaceOrder"]) {
			[preferences setObject:@[
									 @"ml.festival.ActivityAnalog",
									 @"ml.festival.ActivityDigital",
									 @"ml.festival.Numerals",
									 @"ml.festival.Utility",
									 @"ml.festival.Simple",
									 @"ml.festival.Color",
									 @"ml.festival.Chronograph",
									 @"ml.festival.XLarge",
									 @"ml.festival.Weather"
									 ] forKey:@"watchFaceOrder"];
		}
		
		// Disabled watch faces
		if (![preferences objectForKey:@"disabledWatchFaces"]) {
			[preferences setObject:@[] forKey:@"disabledWatchFaces"];
		}
		
		[preferences writeToFile:PREFERENCES_PATH atomically:YES];
#else
		preferences = [[HBPreferences alloc] initWithIdentifier:@"ml.festival.lockwatch"];

		[preferences registerDefaults:@{
										@"enabled": @YES,
										@"watchSize": @"regular",
										@"alwaysMinimized": @NO,
										@"yOffset": @0.0,
										@"watchFaceOrder": @[
												@"ml.festival.ActivityAnalog",
												@"ml.festival.ActivityDigital",
												@"ml.festival.Numerals",
												@"ml.festival.Utility",
												@"ml.festival.Simple",
												@"ml.festival.Color",
												@"ml.festival.Chronograph",
												@"ml.festival.XLarge",
												@"ml.festival.Weather"
												],
										@"disabledWatchFaces": @[]
										}];
#endif*/
	}
	
	return self;
}

- (id)objectForKey:(NSString*)key {
	
	return [preferences objectForKey:key];
}

- (void)setObject:(id)anObject forKey:(nonnull NSString *)aKey {
	[preferences setObject:anObject forKey:aKey];
	
#if (TARGET_OS_SIMULATOR)
	[preferences writeToFile:PREFERENCES_PATH atomically:YES];
#endif
}

@end
