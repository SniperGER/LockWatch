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
		
		/*NSURL* pluginsLocation = [[NSURL fileURLWithPath:@"/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces"] URLByResolvingSymlinksInPath];
		NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:pluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
		NSArray* stockWatchFaces = @[
									 @"ActivityAnalog.watchface",
									 @"ActivityDigital.watchface",
									 @"Numerals.watchface",
									 @"Utility.watchface",
									 @"Simple.watchface",
									 @"Color.watchface",
									 @"Chronograph.watchface",
									 @"XLarge.watchface",
									 ];
		
		contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSURL* name1, NSURL* name2) {
			return [[name1 lastPathComponent] compare:[name2 lastPathComponent] options:NSCaseInsensitiveSearch];
		}];
		
		[contents enumerateObjectsUsingBlock:^(NSURL* externalPlugin, NSUInteger index, BOOL* stop) {
			if ([[externalPlugin pathExtension] isEqualToString:@"watchface"] && [stockWatchFaces indexOfObject:[externalPlugin lastPathComponent]] == NSNotFound) {
				NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:externalPlugin];
				PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]
																		target:self
																		   set:@selector(setValue:specifier:)
																		   get:@selector(getValueForSpecifier:)
																		detail:nil
																		  cell:PSSwitchCell
																		  edit:Nil];
				[specifier setProperty:@YES forKey:@"enabled"];
				[specifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
				[specifiers addObject:specifier];
			}
		}];*/
		
		_specifiers = [specifiers copy];
	}
	
	return _specifiers;
}

@end
