#import <UIKit/UIKit.h>

@class LWPluginManager, LWContainerView, LWInterfaceView, LWKClockBase;

@interface LWCore : NSObject {
	BOOL isUpdatingTime;
	NSTimer* clockUpdateTimer;
	NSTimer* syncTimer;
}

@property (nonatomic, strong) LWPluginManager* pluginManager;
@property (nonatomic, strong) LWKClockBase* currentWatchFace;
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

#pragma mark - Debugging

@interface SBDashBoardNotificationListViewController : UIViewController

- (void)_setListHasContent:(BOOL)arg1;

@end

@interface SBDashBoardMediaArtworkViewController : UIViewController

- (void)willTransitionToPresented:(BOOL)arg1;

@end
