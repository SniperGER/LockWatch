#import "LockWatch.h"

@implementation LWPluginManager

+ (id)pluginPath {
	if ([[[NSBundle mainBundle] bundlePath] containsString:@"SpringBoard.app"]) {
		return [NSString stringWithFormat:@"%@/Watch Faces", RESOURCES_PATH];
	} else {
		return [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/PlugIns"];
	}
}

- (id)init {
    if (self = [super init]) {
        NSURL* pluginsLocation = [[NSURL fileURLWithPath:[self.class pluginPath]] URLByResolvingSymlinksInPath];
        NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:pluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
        
        if (contents.count < 1) {
            NSLog(@"[LockWatch] failed to load any watch faces");
        } else {
            loadedPlugins = [NSMutableArray new];
            
            // Load preinstalled watch faces
            NSArray* stockWatchFaces = @[@"Utility.watchface", @"Simple.watchface"];
            [stockWatchFaces enumerateObjectsUsingBlock:^(NSURL* internalPlugin, NSUInteger index, BOOL* stop) {
                if ([[internalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[internalPlugin lastPathComponent]] != NSNotFound) {
                    
                    NSURL* filePath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", pluginsLocation, internalPlugin]];
                    NSBundle* watchFaceBundle = [NSBundle bundleWithURL:filePath];
                    
                    if (watchFaceBundle) {
                        [loadedPlugins addObject:watchFaceBundle];
                    }
                }
            }];
            
            // Load third-party watch faces (if any)
            [contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
                if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
                    NSLog(@"[LockWatch] Attempting to load %@", [externalPlugin lastPathComponent]);
                    
                    NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
                    
                    if (watchFaceBundle) {
                        [loadedPlugins addObject:watchFaceBundle];
                    }
                }
            }];
        }
    }
    
    return self;
}

- (NSArray*)loadedPlugins {
	return [loadedPlugins copy];
}

@end
