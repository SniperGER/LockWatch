#import <Foundation/Foundation.h>

@interface LWPluginManager : NSObject {
	NSMutableDictionary* loadedPlugins;
}

+ (id)pluginPath;
- (void)loadPlugins;

- (NSDictionary*)loadedPlugins;
- (int)currentWatchFaceIndex;

@end
