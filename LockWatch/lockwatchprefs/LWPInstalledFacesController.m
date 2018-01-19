#import "LWPInstalledFacesController.h"
#import <objc/runtime.h>

@implementation PSSpecifier (Actions)

- (void)setAction:(SEL)arg1 {
	action = arg1;
}

@end

@implementation LWPInstalledFacesController

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray* specifiers = [NSMutableArray new];
		
		NSURL* pluginsLocation = [[NSURL fileURLWithPath:@"/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces"] URLByResolvingSymlinksInPath];
		NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:pluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
		
		if (contents.count < 1) {
			PSSpecifier* noFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[noFacesGroup setProperty:@"LockWatch doesn't seem to know about any Watch Face. I have a bad feeling about this." forKey:@"footerText"];
			[specifiers addObject:noFacesGroup];
		} else {
			
			PSSpecifier* stockFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"Apple Watch" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[specifiers addObject:stockFacesGroup];
			
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
			[stockWatchFaces enumerateObjectsUsingBlock:^(NSURL* internalPlugin, NSUInteger index, BOOL* stop) {
				if ([[internalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[internalPlugin lastPathComponent]] != NSNotFound) {
					NSURL* filePath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", pluginsLocation, internalPlugin]];
					NSBundle* watchFaceBundle = [NSBundle bundleWithURL:filePath];
					
					if (watchFaceBundle) {
						PSSpecifier* faceSpecifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:@selector(getValue:) detail:nil cell:PSSwitchCell edit:nil];
						[faceSpecifier setProperty:@YES forKey:@"enabled"];
						[faceSpecifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
						[specifiers addObject:faceSpecifier];
					}
				}
			}];
			
			PSSpecifier* pluginFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"Additional Watch Faces" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[specifiers addObject:pluginFacesGroup];
			
			// Sort array alphabetically for third-party watch faces
			contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSURL* url1, NSURL* url2) {
				return [[url1 lastPathComponent] compare:[url2 lastPathComponent] options:NSCaseInsensitiveSearch];
			}];
			
			// Load third-party watch faces (if any)
			[contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
				if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
					
					if (watchFaceBundle) {
						PSSpecifier* faceSpecifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:@selector(getValue:) detail:nil cell:PSSwitchCell edit:nil];
						[faceSpecifier setProperty:@YES forKey:@"enabled"];
						[faceSpecifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
						[specifiers addObject:faceSpecifier];
					}
				}
			}];
		}
		
		_specifiers = [specifiers copy];
	}
	
	return _specifiers;
}

- (NSNumber*)getValue:(PSSpecifier*)specifier {
	HBPreferences* preferences = [HBPreferences preferencesForIdentifier:@"ml.festival.lockwatch"];
	NSArray* disabledFaces = [preferences objectForKey:@"disabledWatchFaces"];
	
	NSLog(@"[LockWatch] %@", disabledFaces);
	
	return [NSNumber numberWithBool:![disabledFaces containsObject:[specifier propertyForKey:@"bundleIdentifier"]]];
}

- (void)setValue:(NSNumber*)value forSpecifier:(PSSpecifier*)specifier {
	HBPreferences* preferences = [HBPreferences preferencesForIdentifier:@"ml.festival.lockwatch"];
	NSMutableArray* disabledFaces = [[preferences objectForKey:@"disabledWatchFaces"] mutableCopy];
	
	if (!disabledFaces) {
		disabledFaces = [NSMutableArray new];
	}
	
	if (![disabledFaces containsObject:[specifier propertyForKey:@"bundleIdentifier"]] && ![value boolValue]) {
		[disabledFaces addObject:[specifier propertyForKey:@"bundleIdentifier"]];
	} else if ([disabledFaces containsObject:[specifier propertyForKey:@"bundleIdentifier"]] && [value boolValue]) {
		[disabledFaces removeObject:[specifier propertyForKey:@"bundleIdentifier"]];
	}
	
	[preferences setObject:[disabledFaces copy] forKey:@"disabledWatchFaces"];
}

@end
