#import <Foundation/Foundation.h>

#if (!TARGET_OS_SIMULATOR)
#import <Cephei/HBPreferences.h>
#endif

@interface LWPreferences : NSObject {
#if APP_CONTEXT
	NSMutableDictionary* preferences;
#else
#if (TARGET_OS_SIMULATOR)
	NSMutableDictionary* preferences;
#else
	HBPreferences* preferences;
#endif
#endif
}

+ (_Nonnull id)sharedInstance;
- (_Nonnull id)objectForKey:(NSString* _Nonnull)key;
- (void)setObject:(_Nonnull id)anObject forKey:(NSString * _Nonnull)aKey;

@end
