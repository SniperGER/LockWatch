#import <Foundation/Foundation.h>

@interface LWPluginManager : NSObject {
	NSMutableArray* loadedPlugins;
}

+ (id)pluginPath;

- (NSArray*)loadedPlugins;

@end
