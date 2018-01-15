#import <UIKit/UIKit.h>

@class LWPluginManager, LWContainerView, LWInterfaceView, LWKClockBase;

@interface LWCore : NSObject {
	BOOL isUpdatingTime;
	NSTimer* clockUpdateTimer;
	NSTimer* syncTimer;
}

@property (nonatomic, strong) LWPluginManager* pluginManager;
@property (nonatomic, strong) LWKClockBase* currentWatchFace;
@property (nonatomic, strong) LWKClockBase* previousWatchFace;
@property (nonatomic, strong) LWContainerView* containerView;
@property (nonatomic, strong) LWInterfaceView* interfaceView;
@property (nonatomic, assign) CGRect minimizedFrame;
@property (nonatomic, assign) BOOL isSelecting;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isMinimized;
@property (nonatomic, assign) BOOL isShowingNotifications;
@property (nonatomic, assign) BOOL isShowingMediaArtwork;

+ (id)sharedInstance;
- (void)startUpdatingTime;
- (void)stopUpdatingTime;
- (void)updateTimeForCurrentWatchFace;
- (void)updateTimeWhileTimeIsSyncing;

@end
