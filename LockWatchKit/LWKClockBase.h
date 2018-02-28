#import <UIKit/UIKit.h>

#if (TARGET_OS_SIMULATOR)
#define FACE_PREFERENCES_PATH @"/opt/simject/FESTIVAL/%@.plist"
#else
#define FACE_PREFERENCES_PATH @"/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces/%@.plist"
#endif

@class LWKFaceEditView, LWKCustomizationSelector;

@interface LWKClockBase : NSObject {
	NSTimer* clockUpdateTimer;
	NSMutableDictionary* watchFacePreferences;
	NSArray* customizationOptions;
	
	LWKCustomizationSelector* currentCustomizationSelector;
}

@property (nonatomic, strong, readonly) NSBundle* watchFaceBundle;

@property (nonatomic, strong) UIView* clockView;
@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* indicatorView;
@property (nonatomic, strong) UILabel* dateLabel;

@property (nonatomic, strong) NSMutableArray* detailImages;

@property (nonatomic, strong) LWKFaceEditView* editView;
@property (nonatomic, assign) BOOL isCustomizable;
@property (nonatomic, assign) BOOL isEditing;

- (void)prepareForInit;

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond startAnimation:(BOOL)startAnimation;
- (void)didStartUpdatingTime:(BOOL)animated;
- (void)didStopUpdatingTime:(BOOL)animated;
- (void)triggerUpdate;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

- (NSArray*)faceStyleViews;
- (void)setFaceStyle:(int)style;
- (int)faceStyle;

- (NSArray*)faceDetailViews;
- (void)setFaceDetail:(int)detail;
- (int)faceDetail;

- (void)setAccentColor:(NSString*)color;
- (NSString*)accentColor;

- (void)setComplicationIndex:(int)index forPosition:(NSString*)position;
- (int)complicationIndexForPosition:(NSString*)position;

@end
