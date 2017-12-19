#import <UIKit/UIKit.h>

@class LWKFaceEditView;

@interface LWKClockBase : NSObject {
	NSTimer* clockUpdateTimer;
	NSMutableDictionary* watchFacePreferences;
}

@property (nonatomic, strong, readonly) NSBundle* watchFaceBundle;

@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* clockView;

@property (nonatomic, strong) LWKFaceEditView* editView;
@property (nonatomic, assign) BOOL isCustomizable;
@property (nonatomic, assign) BOOL isEditing;

- (void)didStartUpdatingTime;
- (void)didStopUpdatingTime;
- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated;
- (void)prepareForInit;

- (void)setAccentColor:(UIColor*)color;
- (NSArray*)focussedViewsForEditingPage:(int)page;
- (NSArray*)hiddenViewsForEditingPage:(int)page;

@end
