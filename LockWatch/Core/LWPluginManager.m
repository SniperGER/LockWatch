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
		
		NSArray* stockWatchFaces = @[
									 @"ActivityAnalog.watchface",
									 @"ActivityDigital.watchface",
									 @"Numerals.watchface",
									 @"Utility.watchface",
									 @"Simple.watchface",
									 @"Color.watchface",
									 @"Chronograph.watchface",
									 @"XLarge.watchface"
									 ];
		
		if (contents.count < 1) {
			NSLog(@"[LockWatch] failed to load any watch faces");
		} else {
			loadedPlugins = [NSMutableArray new];
			
			NSArray* disabledFaces = [[LWPreferences sharedInstance] objectForKey:@"disabledWatchFaces"];
			
			// Load preinstalled watch faces
			[stockWatchFaces enumerateObjectsUsingBlock:^(NSURL* internalPlugin, NSUInteger index, BOOL* stop) {
				if ([[internalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[internalPlugin lastPathComponent]] != NSNotFound) {
					NSURL* filePath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", pluginsLocation, internalPlugin]];
					NSBundle* watchFaceBundle = [NSBundle bundleWithURL:filePath];
					
					if (watchFaceBundle && ![disabledFaces containsObject:[watchFaceBundle bundleIdentifier]]) {
						[loadedPlugins addObject:watchFaceBundle];
					}
				}
			}];
			
			// Sort array alphabetically for third-party watch faces
			contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSURL* url1, NSURL* url2) {
				return [[url1 lastPathComponent] compare:[url2 lastPathComponent] options:NSCaseInsensitiveSearch];
			}];
			
			// Load third-party watch faces (if any)
			[contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
				if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
					
					if (watchFaceBundle && ![disabledFaces containsObject:[watchFaceBundle bundleIdentifier]]) {
						[loadedPlugins addObject:watchFaceBundle];
					}
				}
			}];
		}
		
		// Load watch faces from iTunes File Sharing
#if APP_CONTEXT
		NSURL* iTunesPluginsLocation = [[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] URLByResolvingSymlinksInPath];
		contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:iTunesPluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
		
		if (contents.count > 0) {
			contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSURL* url1, NSURL* url2) {
				return [[url1 lastPathComponent] compare:[url2 lastPathComponent] options:NSCaseInsensitiveSearch];
			}];
			
			[contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
				if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
					
					if (watchFaceBundle) {
						[loadedPlugins addObject:watchFaceBundle];
					}
				}
			}];
		}
#endif
	}
	
	return self;
}

- (NSArray*)loadedPlugins {
	return [loadedPlugins copy];
}

- (NSArray*)loadedPluginIdentifiers {
	NSMutableArray* identifiers = [NSMutableArray new];
	
	for (NSBundle* bundle in loadedPlugins) {
		[identifiers addObject:[bundle bundleIdentifier]];
	}
	
	return [identifiers copy];
}

- (int)currentWatchFaceIndex {
	int index = -1;
	
	for (int i=0; i<loadedPlugins.count; i++) {
		if ([[loadedPlugins[i] bundleIdentifier] isEqualToString:[[LWPreferences sharedInstance] objectForKey:@"selectedWatchFace"]]) {
			index = i;
			break;
		}
	}
	
	return index;
}

@end
