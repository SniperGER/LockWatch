#import <CepheiPrefs/HBListController.h>
#import <Cephei/HBPreferences.h>
#import <Preferences/PSEditableListController.h>

@interface PSSpecifier {
	SEL action;
}
+(id)preferenceSpecifierNamed:(id)arg1 target:(id)arg2 set:(SEL)arg3 get:(SEL)arg4 detail:(Class)arg5 cell:(long long)arg6 edit:(Class)arg7 ;
- (id)propertyForKey:(NSString*)key;
- (void)setProperty:(id)property forKey:(NSString*)key;
@end

@interface PSSpecifier (Actions)
- (void)setAction:(SEL)action;
@end

@interface LWPreferences : NSObject
+ (id)sharedInstance;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
@end

typedef enum PSCellType {
	PSGroupCell,
	PSLinkCell,
	PSLinkListCell,
	PSListItemCell,
	PSTitleValueCell,
	PSSliderCell,
	PSSwitchCell,
	PSStaticTextCell,
	PSEditTextCell,
	PSSegmentCell,
	PSGiantIconCell,
	PSGiantCell,
	PSSecureEditTextCell,
	PSButtonCell,
	PSEditTextViewCell,
} PSCellType;

@interface LWPInstalledFacesController : PSEditableListController {
	NSMutableArray* enabledFaces;
	NSMutableArray* disabledFaces;
}

@end
