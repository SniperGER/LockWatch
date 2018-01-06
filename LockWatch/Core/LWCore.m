#import "LockWatch.h"

@implementation LWCore

static LWCore* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		dlopen([[NSString stringWithFormat:@"%@/LockWatchKit.framework/LockWatchKit", RESOURCES_PATH] UTF8String], RTLD_NOW);
		dlopen("/System/Library/PrivateFrameworks/MaterialKit.framework/MaterialKit", RTLD_NOW);
		
		_pluginManager = [LWPluginManager new];
		
		CGSize interfaceSize = [LWMetrics watchSize];
		_interfaceView = [[LWInterfaceView alloc] initWithFrame:CGRectMake(0, screenHeight/2 - interfaceSize.height/2, screenWidth, interfaceSize.height)];
		
		if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
		}
	}
	
	return self;
}

- (void)orientationChanged {
	[_interfaceView setFrame:CGRectMake(0, 0, screenWidth, 390)];
	[_interfaceView setCenter:CGPointMake(screenWidth / 2, screenHeight / 2)];
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
		[_interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES];
	}
	
	if (isMinimized) {
		CGSize interfaceSize = [LWMetrics watchSize];
		CGRect labelFrame;
		
#if !APP_CONTEXT
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			labelFrame = [[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] dateViewController] view].frame;
		}
#endif
		
		CGRect oldFrame = CGRectMake(0, screenHeight/2 - interfaceSize.height/2, screenWidth, interfaceSize.height);
		CGFloat scale = labelFrame.size.height / interfaceSize.width;
		
		[UIView animateWithDuration:0.25 animations:^{
			CGAffineTransform transform = CGAffineTransformIdentity;
			
			transform = CGAffineTransformTranslate(transform, 0, (labelFrame.origin.y - oldFrame.origin.y) - (interfaceSize.height / 2) + labelFrame.size.height/2);
			transform = CGAffineTransformScale(transform, scale, scale);
			
			[_interfaceView setTransform:transform];
		}];
	} else {
		[UIView animateWithDuration:0.25 animations:^{
			[_interfaceView setTransform:CGAffineTransformIdentity];
		}];
	}
}

//- (BOOL)isUpdatingTime {}

- (void)startUpdatingTime {
	if (isUpdatingTime || !_currentWatchFace) {
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
