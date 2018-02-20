#import <Foundation/Foundation.h>

#if (!TARGET_OS_SIMULATOR)
#import <Cephei/HBPreferences.h>
#endif

@interface LWPreferences : NSObject {
/*#if APP_CONTEXT
	NSUserDefaults* preferences;
#else
#if (TARGET_OS_SIMULATOR)
	NSMutableDictionary* preferences;
#else
	HBPreferences* preferences;
#endif
#endif*/
#if APP_CONTEXT
	NSUserDefaults* preferences;
#else
	NSMutableDictionary* preferences;
#endif
}

+ (id)sharedInstance;
- (void)loadPreferences;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

@end
