#import <Foundation/Foundation.h>

#if (!TARGET_OS_SIMULATOR)
#import <Cephei/HBPreferences.h>
#endif

@interface LWPreferences : NSObject {
//#if (TARGET_OS_SIMULATOR)
//	NSMutableDictionary* preferences;
//#else
//	HBPreferences* preferences;
//#endif
	
	NSMutableDictionary* preferences;
}

+ (_Nonnull id)sharedInstance;
- (_Nonnull id)objectForKey:(NSString* _Nonnull)key;
- (void)setObject:(_Nonnull id)anObject forKey:(NSString * _Nonnull)aKey;

@end
