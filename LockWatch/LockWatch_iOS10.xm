#import "LockWatch.h"

@interface SBDashBoardCombinedListViewController : UIViewController
@end

@interface NCNotificationCombinedListViewController : UIViewController
@end

%group os10

LWCore* lockwatch;
SBDashBoardMainPageViewController* mainPage;

BOOL hasNotifications;
BOOL mediaControlsVisible;

void setLockWatchVisibility() {
	[[mainPage isolatingViewController].view setHidden:(!hasNotifications && !mediaControlsVisible)];
	
	//[lockwatch.interfaceView setHidden:mediaControlsVisible];
	//[lockwatch setIsMinimized:(hasNotifications && !mediaControlsVisible)];
	[lockwatch setIsShowingNotifications:hasNotifications];
	[lockwatch setIsShowingMediaArtwork:mediaControlsVisible];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	
	lockwatch = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	
	
	if ([dashBoard respondsToSelector:@selector(mainPageViewController)]) {
		mainPage = [dashBoard mainPageViewController];
	} else if ([dashBoard respondsToSelector:@selector(mainPageContentViewController)]) {
		mainPage = [dashBoard mainPageContentViewController];
	}
	
	[mainPage.view insertSubview:lockwatch.containerView atIndex:0];
	setLockWatchVisibility();
}

%end	// %hook SpringBoard

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES didCancel:NO];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES didCancel:YES];
	} else {
		%orig;
	}
}

%end	// %hook SBLockScreenManager

%hook SBFLockScreenDateView

- (void)layoutSubviews {
	[MSHookIvar<UILabel *>(self,"_timeLabel") removeFromSuperview];
	[MSHookIvar<UILabel *>(self,"_dateSubtitleView") removeFromSuperview];
	[MSHookIvar<UILabel *>(self,"_customSubtitleView") removeFromSuperview];

	[lockwatch setMinimizedFrame:self.frame];
	setLockWatchVisibility();
	
	%orig;
}

%end	// %hook SBFLockScreenDateView

%hook SBDashBoardViewController

- (void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	setLockWatchVisibility();
	
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES didCancel:NO];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES didCancel:NO];
	} else {
		[lockwatch setOverrideScreenOffState:YES];
		[lockwatch startUpdatingTime:NO];
		
		[lockwatch updateTimeForCurrentWatchFace:NO];
		[lockwatch updateTimeWhileTimeIsSyncing];
	}
	
	%orig;
}

%new
- (SBDashBoardScrollGestureController*)scrollGestureController {
	return MSHookIvar<SBDashBoardScrollGestureController*>(self,"_scrollGestureController");
}

%end	// %hook SBDashBoardViewController

%hook SBDashBoardScrollGestureController

%new
- (SBPagedScrollView*)scrollView {
	return MSHookIvar<SBPagedScrollView*>(self, "_scrollView");
}

%end	// %hook SBDashBoardScrollGestureController

%hook SBDashBoardNotificationListViewController

- (void)_setListHasContent:(BOOL)arg1 {
	%orig;
	
	hasNotifications = arg1;
	setLockWatchVisibility();
}

%end	// %hook SBDashBoardNotificationListViewController

%hook SBDashBoardMediaArtworkViewController

- (void)willTransitionToPresented:(BOOL)arg1 {
	%orig;
	
	mediaControlsVisible = arg1;
	setLockWatchVisibility();
}

%end	// %hook SBDashBoardMediaArtworkViewController

%hook SBBacklightController

- (void)_lockScreenDimTimerFired {
	if (lockwatch.isSelecting || lockwatch.isEditing) {
		[self resetIdleTimer];
		return;
	}

	%orig;
}

- (void)_startFadeOutAnimationFromLockSource:(int)arg1 {
	if (arg1 == 11 && (lockwatch.isSelecting || lockwatch.isEditing)) {
		[self resetIdleTimer];
		return;
	}

	%orig;
}

%end	// %hook SBBacklightController

// iOS 11
%hook SBDashBoardCombinedListViewController

- (void)viewDidLayoutSubviews {
	[self.view removeFromSuperview];
}

%end	// %hook SBDashBoardCombinedListViewController

// iOS 11
%hook NCNotificationCombinedListViewController

- (BOOL)hasVisibleContent {
	BOOL r = %orig;
	hasNotifications = r;
	[self.view setHidden:!r];
	setLockWatchVisibility();
	
	return r;
}

%end	// %hook NCNotificationCombinedListViewController

static void DeviceLockedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LockWatchDeviceLocked" object:nil];
}

%end	// %group os10

%ctor {
	id preferences = [[LWPreferences alloc] init];
	
	if ([[preferences objectForKey:@"enabled"] boolValue]) {
		%init(os10);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, DeviceLockedCallback, CFSTR("com.apple.springboard.lockcomplete"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
