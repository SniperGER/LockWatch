#import <UIKit/UIKit.h>

@class LWPluginManager, LWInterfaceView, LWKClockBase;

@interface LWCore : NSObject {
	BOOL isUpdatingTime;
	NSTimer* clockUpdateTimer;
}

@property (nonatomic, strong) LWPluginManager* pluginManager;
@property (nonatomic, strong) LWKClockBase* currentWatchFace;

@property (nonatomic, strong) LWInterfaceView* interfaceView;
@property (nonatomic, assign) BOOL isSelecting;
@property (nonatomic, assign) BOOL isEditing;

+ (id)sharedInstance;
- (void)startUpdatingTime;
- (void)stopUpdatingTime;
- (void)updateTimeForCurrentWatchFace;

@end
