#import <Foundation/Foundation.h>

@interface LWPluginManager : NSObject {
	NSMutableArray* loadedPlugins;
}

- (NSArray*)loadedPlugins;

@end
