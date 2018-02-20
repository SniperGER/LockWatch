#import "LWPInstalledFacesController.h"
#import <objc/runtime.h>

@implementation PSSpecifier (Actions)

- (void)setAction:(SEL)arg1 {
	action = arg1;
}

@end

@implementation LWPInstalledFacesController

- (NSArray *)specifiers {
	if (!enabledFaces && !disabledFaces) {
		enabledFaces = [NSMutableArray new];
		disabledFaces = [NSMutableArray new];
	}
	
	
	if (!_specifiers) {
		NSMutableArray* specifiers = [NSMutableArray new];
		
		NSURL* pluginsLocation = [[NSURL fileURLWithPath:@"/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces"] URLByResolvingSymlinksInPath];
		NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:pluginsLocation includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
		
		if (contents.count < 1) {
			PSSpecifier* noFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[noFacesGroup setProperty:@"LockWatch doesn't seem to know about any Watch Face. I have a bad feeling about this." forKey:@"footerText"];
			[specifiers addObject:noFacesGroup];
		} else {
			NSDictionary* preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/ml.festival.lockwatch.plist"];
			
			NSMutableDictionary* _enabledFaces = [NSMutableDictionary new];
			NSMutableDictionary* _disabledFaces = [NSMutableDictionary new];
			
			[contents enumerateObjectsUsingBlock:^(NSURL* plugin, NSUInteger index, BOOL* stop) {
				if ([[plugin pathExtension] isEqualToString:@"watchface"]) {
					NSBundle* watchFaceBundle = [[NSBundle alloc] initWithURL:plugin];
					
					if (watchFaceBundle) {
						if ([[preferences objectForKey:@"watchFaceOrder"] containsObject:[watchFaceBundle bundleIdentifier]]) {
							[_enabledFaces setObject:watchFaceBundle forKey:[watchFaceBundle bundleIdentifier]];
						} else {
							[_disabledFaces setObject:watchFaceBundle forKey:[watchFaceBundle bundleIdentifier]];
						}
						/*PSSpecifier* faceSpecifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:@selector(getValue:) detail:nil cell:PSStaticTextCell edit:nil];
						[faceSpecifier setProperty:@YES forKey:@"enabled"];
						[faceSpecifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
						[specifiers addObject:faceSpecifier];*/
					}
				}
			}];
			
			PSSpecifier* activeFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"Enabled" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[specifiers addObject:activeFacesGroup];
			
			for (NSString* bundleId in [preferences objectForKey:@"watchFaceOrder"]) {
				NSBundle* watchFaceBundle = [_enabledFaces objectForKey:bundleId];
				
				[enabledFaces addObject:bundleId];
				
				PSSpecifier* faceSpecifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:@selector(getValue:) detail:nil cell:PSStaticTextCell edit:nil];
				[faceSpecifier setProperty:@YES forKey:@"enabled"];
				[faceSpecifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
				[specifiers addObject:faceSpecifier];
			}
			
			PSSpecifier* disabledFacesGroup = [PSSpecifier preferenceSpecifierNamed:@"Disabled" target:self set:NULL get:NULL detail:Nil cell:PSGroupCell edit:Nil];
			[specifiers addObject:disabledFacesGroup];
			
			for (NSString* bundleId in [preferences objectForKey:@"disabledWatchFaces"]) {
				NSBundle* watchFaceBundle = [_disabledFaces objectForKey:bundleId];
				
				[disabledFaces addObject:bundleId];
				
				PSSpecifier* faceSpecifier = [PSSpecifier preferenceSpecifierNamed:[watchFaceBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:@selector(getValue:) detail:nil cell:PSStaticTextCell edit:nil];
				[faceSpecifier setProperty:@YES forKey:@"enabled"];
				[faceSpecifier setProperty:[watchFaceBundle bundleIdentifier] forKey:@"bundleIdentifier"];
				[specifiers addObject:faceSpecifier];
			}
		}
		
		_specifiers = [specifiers copy];
	}
	
	return _specifiers;
}

/*- (NSNumber*)getValue:(PSSpecifier*)specifier {
	HBPreferences* preferences = [HBPreferences preferencesForIdentifier:@"ml.festival.lockwatch"];
	NSArray* disabledFaces = [preferences objectForKey:@"disabledWatchFaces"];
	
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
}*/

/*- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,100,100)];
	[cell.textLabel setText:@"test"];
	
	return cell;
}*/

- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
	NSString* movedObject = nil;
	if (fromIndexPath.section == 0) {
		movedObject = [[enabledFaces objectAtIndex:fromIndexPath.row] copy];
		[enabledFaces removeObjectAtIndex:fromIndexPath.row];
	} else if (fromIndexPath.section == 1) {
		movedObject = [[disabledFaces objectAtIndex:fromIndexPath.row] copy];
		[disabledFaces removeObjectAtIndex:fromIndexPath.row];
	}
	
	if (toIndexPath.section == 0) {
		[enabledFaces insertObject:movedObject atIndex:toIndexPath.row];
	} else if (toIndexPath.section == 1) {
		[disabledFaces insertObject:movedObject atIndex:toIndexPath.row];
	}
	
	NSMutableDictionary* preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/ml.festival.lockwatch.plist"];
	[preferences setObject:enabledFaces forKey:@"watchFaceOrder"];
	[preferences setObject:disabledFaces forKey:@"disabledWatchFaces"];
	[preferences writeToFile:@"/var/mobile/Library/Preferences/ml.festival.lockwatch.plist" atomically:YES];
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("ml.festival.lockwatch.watchfaceorder"), NULL, NULL, YES);
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
	return NO;
}

@end
