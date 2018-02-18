#import "LockWatch.h"

@implementation LWPreferences

static LWPreferences* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

+ (id)defaults {
	return @{
			 @"enabled": @YES,
			 @"selectedWatchFace": @"ml.festival.ActivityAnalog",
			 @"watchFaceOrder": [@[
								   @"ml.festival.ActivityAnalog",
								   @"ml.festival.ActivityDigital",
								   @"ml.festival.Numerals",
								   @"ml.festival.Utility",
								   @"ml.festival.Simple",
								   @"ml.festival.Color",
								   @"ml.festival.Chronograph",
								   @"ml.festival.XLarge",
								   ] mutableCopy],
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
#else
//#if (TARGET_OS_SIMULATOR)
		preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
		
		if (!preferences) {
			preferences = [NSMutableDictionary new];
		}
		
		for (id key in self.class.defaults) {
			if (![preferences objectForKey:key]) {
				[preferences setObject:[self.class.defaults objectForKey:key] forKey:key];
			}
		}
		
		[preferences writeToFile:PREFERENCES_PATH atomically:YES];
/*#else
		preferences = [[HBPreferences alloc] initWithIdentifier:@"ml.festival.lockwatch"];
		
		[preferences registerDefaults:self.class.defaults];
#endif*/
#endif

	}
	
	return self;
}

- (id)objectForKey:(NSString*)key {
	
	return [preferences objectForKey:key];
}

- (void)setObject:(id)anObject forKey:(nonnull NSString *)aKey {
	[preferences setObject:anObject forKey:aKey];
	
#if (!APP_CONTEXT)
	[preferences writeToFile:PREFERENCES_PATH atomically:YES];
#endif
}

@end
