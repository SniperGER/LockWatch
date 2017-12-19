#import "LockWatch.h"

@interface SBDashBoardCombinedListViewController : UIViewController
@end

%group os10

LWCore* lockwatch;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	
	lockwatch = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	SBDashBoardMainPageViewController* mainPage;
	
	if ([dashBoard respondsToSelector:@selector(mainPageViewController)]) {
		mainPage = [dashBoard mainPageViewController];
	} else if ([dashBoard respondsToSelector:@selector(mainPageContentViewController)]) {
		mainPage = [dashBoard mainPageContentViewController];
	}
	
	[mainPage.view insertSubview:lockwatch.interfaceView atIndex:0];
	[[mainPage isolatingViewController].view removeFromSuperview];
}

%end	// %hook SpringBoard

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES];
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
	
	%orig;
}

%end	// %hook SBFLockScreenDateView

%hook SBDashBoardViewController

- (void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES];
	} else {
		[lockwatch updateTimeForCurrentWatchFace];
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

%hook SBBacklightController

- (void)_lockScreenDimTimerFired {
	/*if (lockwatch.isSelecting || lockwatch.isEditing) {
		[self resetIdleTimer];
		return;
	}
	
	%orig;*/
	
	return;
}

- (void)_startFadeOutAnimationFromLockSource:(int)arg1 {
	/*if (arg1 == 11 && (lockwatch.isSelecting || lockwatch.isEditing)) {
		[self resetIdleTimer];
		return;
	}
	
	%orig;*/
	return;
}

%end	// %hook SBBacklightController

// iOS 11
%hook SBDashBoardCombinedListViewController

- (void)viewDidLayoutSubviews {
	[self.view removeFromSuperview];
}

%end	// %hook SBDashBoardCombinedListViewController

%end	// %group os10

%ctor {
	id preferences = [[LWPreferences alloc] init];
	
	if ([[preferences objectForKey:@"enabled"] boolValue]) {
		%init(os10);
	}
}
