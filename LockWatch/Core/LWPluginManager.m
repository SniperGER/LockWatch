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
			loadedPlugins = [NSMutableDictionary new];
			
			NSMutableArray* watchFaceOrder = [[LWPreferences sharedInstance] objectForKey:@"watchFaceOrder"];
			NSArray* disabledFaces = [[LWPreferences sharedInstance] objectForKey:@"disabledWatchFaces"];
			
			// Load third-party watch faces (if any)
			[contents enumerateObjectsUsingBlock:^(NSURL* plugin, NSUInteger index, BOOL* stop) {
				if ([[plugin pathExtension] isEqualToString:@"watchface"]) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:plugin];

					if (watchFaceBundle && [watchFaceBundle load]  && ![disabledFaces containsObject:[watchFaceBundle bundleIdentifier]]) {
						if (![watchFaceOrder containsObject:[watchFaceBundle bundleIdentifier]]) {
							[watchFaceOrder addObject:[watchFaceBundle bundleIdentifier]];
						}
						
						[loadedPlugins setObject:watchFaceBundle forKey:[watchFaceBundle bundleIdentifier]];
					} else {
						NSLog(@"[LockWatch] watch face with identifier %@ failed to load", [watchFaceBundle bundleIdentifier]);
					}
				}
			}];
			
			[[LWPreferences sharedInstance] setObject:watchFaceOrder forKey:@"watchFaceOrder"];
		}
		
		// Load watch faces from iTunes File Sharing
/*#if APP_CONTEXT
		NSURL* iTunesPluginsLocation = [[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] URLByResolvingSymlinksInPath];
		contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:iTunesPluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
		
		if (contents.count > 0) {
			contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSURL* url1, NSURL* url2) {
				return [[url1 lastPathComponent] compare:[url2 lastPathComponent] options:NSCaseInsensitiveSearch];
			}];
			
			[contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
				if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
					
					if (watchFaceBundle && [watchFaceBundle load]) {
						[loadedPlugins addObject:watchFaceBundle];
					} else {
						NSLog(@"[LockWatch] watch face with identifier %@ failed to load", [watchFaceBundle bundleIdentifier]);
					}
				}
			}];
		}
#endif*/
	}
	
	return self;
}

- (NSDictionary*)loadedPlugins {
	return [loadedPlugins copy];
}

- (int)currentWatchFaceIndex {
	int index = -1;
	
	NSArray* watchFaceOrder = [[LWPreferences sharedInstance] objectForKey:@"watchFaceOrder"];
	for (int i=0; i<watchFaceOrder.count; i++) {
		if ([watchFaceOrder[i] isEqualToString:[[LWPreferences sharedInstance] objectForKey:@"selectedWatchFace"]]) {
			index = i;
			break;
		}
	}
	
	return index;
}

@end
