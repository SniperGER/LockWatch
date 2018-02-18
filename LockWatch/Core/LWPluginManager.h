#import <Foundation/Foundation.h>

@interface LWPluginManager : NSObject {
	NSMutableDictionary* loadedPlugins;
}

+ (id)pluginPath;

- (NSDictionary*)loadedPlugins;
- (int)currentWatchFaceIndex;

@end
