#import "LockWatch.h"

@implementation LWCore

static LWCore* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		dlopen("/System/Library/Frameworks/LockWatchKit.framework/LockWatchKit", RTLD_NOW);
		dlopen("/System/Library/PrivateFrameworks/MaterialKit.framework/MaterialKit", RTLD_NOW);
		
#if !APP_CONTEXT
		dlopen("/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/UserNotificationsUIKit", RTLD_NOW);
#endif
		_pluginManager = [LWPluginManager new];
		
		_containerView = [[LWContainerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		_interfaceView = _containerView.interfaceView;
		
		if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
		}
	}
	
	return self;
}

- (void)orientationChanged {
//	[_containerView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	
	if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
			[self applyIpadLandscapeLayout];
	} else {
		[self applyPortraitLayout];
	}
}

- (void)setIsSelecting:(BOOL)isSelecting{
	_isSelecting = isSelecting;
	
#if !APP_CONTEXT
	// Fix for iOS 11
	if ([[objc_getClass("SBBacklightController") sharedInstance] respondsToSelector:@selector(resetIdleTimer)]) {
		[[objc_getClass("SBBacklightController") sharedInstance] resetIdleTimer];
	}
	
	if (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
		// iOS 9
	} else {
		// iOS 10 - 11
		
		[[[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] scrollGestureController] scrollView] setScrollEnabled:(!_isSelecting && !_isEditing)];
	}
#endif
}

- (void)setIsMinimized:(BOOL)isMinimized {
	if (isMinimized == _isMinimized) {
		return;
	}
	
	_isMinimized = isMinimized;
	[_interfaceView setUserInteractionEnabled:!isMinimized];
	
	if (self.isSelecting) {
		[_interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES didCancel:NO];
	}
	
//	if (isMinimized) {
//		CGRect labelFrame;
//		
//#if !APP_CONTEXT
//		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
//			labelFrame = [[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] dateViewController] view].frame;
//		}
//#endif
//		
//		CGRect oldFrame = CGRectMake(0, screenHeight/2 - [LWMetrics watchHeight]/2, screenWidth, [LWMetrics watchHeight]);
//		CGFloat scale = labelFrame.size.height / [LWMetrics watchHeight];
//		
//		[UIView animateWithDuration:0.25 animations:^{
//			CGAffineTransform transform = CGAffineTransformIdentity;
//			
//			transform = CGAffineTransformTranslate(transform, 0, (labelFrame.origin.y - oldFrame.origin.y) - ([LWMetrics watchHeight] / 2) + labelFrame.size.height/2);
//			transform = CGAffineTransformScale(transform, scale, scale);
//			
//			[_interfaceView setTransform:transform];
//		}];
//	} else {
//		[UIView animateWithDuration:0.25 animations:^{
//			[_interfaceView setTransform:CGAffineTransformIdentity];
//		}];
//	}
}

- (void)applyPortraitLayout {
	[_containerView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	[_interfaceView setUserInteractionEnabled:(!self.isShowingNotifications && !self.isShowingMediaArtwork)];
	
//	if (self.isSelecting) {
//		[_interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES didCancel:NO];
//	}
	
	if (self.isShowingNotifications) {
		CGRect labelFrame;
		
#if !APP_CONTEXT
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			labelFrame = [[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] dateViewController] view].frame;
		}
#endif
		
		CGRect oldFrame = CGRectMake(0, screenHeight/2 - [LWMetrics watchHeight]/2, screenWidth, [LWMetrics watchHeight]);
		CGFloat scale = labelFrame.size.height / [LWMetrics watchHeight];
		
		[UIView animateWithDuration:0.25 animations:^{
			CGAffineTransform transform = CGAffineTransformIdentity;
			
			transform = CGAffineTransformTranslate(transform, 0, (labelFrame.origin.y - oldFrame.origin.y) - ([LWMetrics watchHeight] / 2) + labelFrame.size.height/2);
			transform = CGAffineTransformScale(transform, scale, scale);
			
			[_interfaceView setTransform:transform];
		}];
	} else {
		[UIView animateWithDuration:0.25 animations:^{
			[_interfaceView setTransform:CGAffineTransformIdentity];
		}];
	}
	
	[_containerView setHidden:self.isShowingMediaArtwork];
}

- (void)applyIpadLandscapeLayout {
	[_interfaceView setTransform:CGAffineTransformIdentity];
	[_interfaceView setUserInteractionEnabled:!(self.isShowingNotifications && self.isShowingMediaArtwork)];
	
	if (self.isShowingNotifications && !self.isShowingMediaArtwork) {
		[_containerView setHidden:NO];
		[_containerView setFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, screenHeight)];
	}
	
	if (!self.isShowingNotifications && self.isShowingMediaArtwork) {
		[_containerView setHidden:NO];
		[_containerView setFrame:CGRectMake(0, 0, screenWidth/2, screenHeight)];
	}
	
	if (self.isShowingNotifications && self.isShowingMediaArtwork) {
		[_containerView setHidden:YES];
	}
	
	if (!self.isShowingNotifications && !self.isShowingMediaArtwork) {
		[_containerView setHidden:NO];
		[_containerView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	}
}

- (void)setIsShowingNotifications:(BOOL)isShowingNotifications {
	if (_isShowingNotifications == isShowingNotifications) {
		return;
	}
	
	_isShowingNotifications = isShowingNotifications;
	
	if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
		[UIView animateWithDuration:0.25 animations:^{
			[self applyIpadLandscapeLayout];
		}];
	} else {
		[self applyPortraitLayout];
	}
}

- (void)setIsShowingMediaArtwork:(BOOL)isShowingMediaArtwork {
	if (_isShowingMediaArtwork == isShowingMediaArtwork) {
		return;
	}
	
	_isShowingMediaArtwork = isShowingMediaArtwork;
	
	if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
		[UIView animateWithDuration:0.25 animations:^{
			[self applyIpadLandscapeLayout];
		}];
	} else {
		[self applyPortraitLayout];
	}
}

//- (BOOL)isUpdatingTime {}

- (void)startUpdatingTime {
	if (isUpdatingTime || !_currentWatchFace || _isSelecting || _isEditing) {
		return;
	}
	
	NSLog(@"start updating time");
	
	isUpdatingTime = YES;
	[_currentWatchFace didStartUpdatingTime];
	clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTimeForCurrentWatchFace) userInfo:nil repeats:YES];
	syncTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateTimeWhileTimeIsSyncing) userInfo:nil repeats:YES];
}

- (void)stopUpdatingTime {
	if (!isUpdatingTime) {
		return;
	}
	
	NSLog(@"stop updating time");
	
	[clockUpdateTimer invalidate];
	clockUpdateTimer = nil;
	
	[syncTimer invalidate];
	syncTimer = nil;
	
	isUpdatingTime = NO;
	
	[_currentWatchFace didStopUpdatingTime];
}

- (void)updateTimeForCurrentWatchFace {
	NSDate* date = [NSDate date];
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents* hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents* minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents* secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents* mSecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float hour = [hourComp hour];
	float minute = [minuteComp minute];
	float second = [secondComp second];
	float mSecond = roundf([mSecondComp nanosecond]/1000000);
	
	if (mSecond >= 0 && mSecond <= 10 && clockUpdateTimer.timeInterval < 0.5) {
		[clockUpdateTimer invalidate];
		clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimeForCurrentWatchFace) userInfo:nil repeats:YES];
		
		if (_currentWatchFace && [_currentWatchFace isKindOfClass:NSClassFromString(@"LWKDigitalClock")]) {
			[_currentWatchFace updateForHour:hour minute:minute second:second millisecond:mSecond animated:YES];
		}
		
		[syncTimer invalidate];
		syncTimer = nil;
		
		return;
	} else if (mSecond < 1000 && mSecond > 750 && clockUpdateTimer.timeInterval >= 0.5) {
		[clockUpdateTimer invalidate];
		clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTimeForCurrentWatchFace) userInfo:nil repeats:YES];
		
		if (!syncTimer) {
			syncTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateTimeWhileTimeIsSyncing) userInfo:nil repeats:YES];
		}

		return;
	} else if (_currentWatchFace && clockUpdateTimer.timeInterval >= 0.5) {
		[_currentWatchFace updateForHour:hour minute:minute second:second millisecond:(mSecond + 250) animated:YES];
		
		[syncTimer invalidate];
		syncTimer = nil;
	}
}

- (void)updateTimeWhileTimeIsSyncing {
	NSDate* date = [NSDate date];
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents* hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents* minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents* secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents* mSecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float hour = [hourComp hour];
	float minute = [minuteComp minute];
	float second = [secondComp second];
	float mSecond = roundf([mSecondComp nanosecond]/1000000);
	
	if (_currentWatchFace) {
		[_currentWatchFace updateForHour:hour minute:minute second:second millisecond:(mSecond + 250) animated:YES];
	}
}

@end
