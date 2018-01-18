#import "LockWatch.h"

#define contentScale (188.0/312.0)
#define overlayScale (364.0/220.0)

@implementation LWScrollView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [LWMetrics watchWidth] + ([LWMetrics facePageSpacing]*2), [LWMetrics watchHeight])];
		[contentView setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))];
		[contentView setPagingEnabled:YES];
		[contentView setClipsToBounds:NO];
		[contentView setShowsHorizontalScrollIndicator:NO];
		[contentView setDelegate:self];
		[self addSubview:contentView];
		
		overlayView = [[LWFaceLibraryOverlayView alloc] initWithFrame:CGRectMake(0, 0, [LWMetrics watchWidth], [LWMetrics watchHeight])];
		[overlayView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
		[overlayView setTransform:CGAffineTransformMakeScale(overlayScale, overlayScale)];
		[overlayView setAlpha:0.0];
		[self addSubview:overlayView];
		
		[overlayView.customizeButton addTarget:self action:@selector(customizeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		[self loadWatchFaces];
		
		tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
		[tapGestureRecognizer setEnabled:NO];
		[self addGestureRecognizer:tapGestureRecognizer];
		
		longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed)];
		[longPressGestureRecognizer setEnabled:![self forceTouchCapable]];
		[self addGestureRecognizer:longPressGestureRecognizer];
	}
	
	return self;
}

#pragma mark Instance Methods

- (void)loadWatchFaces {
	watchFacePages = [NSMutableArray new];
	watchFaces = [NSMutableArray new];
	
	CGFloat scrollViewSpacing = [LWMetrics facePageSpacing];
	
	NSArray* loadedPlugins = [[[LWCore sharedInstance] pluginManager] loadedPlugins];
	for (NSBundle* plugin in loadedPlugins) {
		int i = (int)[loadedPlugins indexOfObject:plugin];
		
		@try {
			LWKPageView* page = [[LWKPageView alloc] initWithFrame:CGRectMake(scrollViewSpacing + (i * ([LWMetrics watchWidth] + (scrollViewSpacing * 2))), 0, [LWMetrics watchWidth], [LWMetrics watchHeight])];
			[page setTransform:CGAffineTransformMakeTranslation(0, [[LWMetrics sizeClass] isEqualToString:@"compact"] ? -13.0 : 0.0)];
			[contentView addSubview:page];
			[watchFacePages addObject:page];
			
			LWKClockBase* watchFace = [[plugin principalClass] new];
			[page setWatchFace:watchFace];
			[page addSubview:watchFace.clockView];
			[watchFaces addObject:watchFace];
			
			[watchFace.clockView setTransform:CGAffineTransformMakeScale([LWMetrics interfaceScale], [LWMetrics interfaceScale])];
			[watchFace.clockView setCenter:CGPointMake([LWMetrics watchWidth]/2, [LWMetrics watchHeight]/2)];
			
			[watchFace prepareForInit];
			
			[overlayView addTitle:[[plugin objectForInfoDictionaryKey:@"CFBundleDisplayName"] uppercaseString]];
		} @catch (NSException* exception) {
			NSLog(@"[LockWatch] Failed to load a watch face. %@", exception.reason);
		}
	}
	
	[contentView setContentSize:CGSizeMake(watchFaces.count * ([LWMetrics watchWidth] + (scrollViewSpacing * 2)), [LWMetrics watchHeight])];
	
	int currentWatchFaceIndex = 0;
	
	if ([[LWPreferences sharedInstance] objectForKey:@"selectedWatchFace"]) {
		currentWatchFaceIndex = (int)MAX(MIN([[[LWPreferences sharedInstance] objectForKey:@"watchFaceOrder"] indexOfObject:[[LWPreferences sharedInstance] objectForKey:@"selectedWatchFace"]], watchFaces.count-1), 0);
	}
	
	[[LWPreferences sharedInstance] setObject:[[watchFaces[currentWatchFaceIndex] watchFaceBundle] bundleIdentifier] forKey:@"selectedWatchFace"];
	
	if (watchFaces.count > currentWatchFaceIndex) {
		[contentView setContentOffset:CGPointMake(currentWatchFaceIndex * contentView.bounds.size.width, 0)];
		[self setWatchFacePageAlpha:[self currentWatchFacePage] alpha:1.0];
		[self setWatchFaceBackgroundAlpha:[self currentWatchFacePage] alpha:0.0];
		[self setWatchFacePagesAlpha:0.0 exceptForPage:[self currentWatchFacePage]];
		[self setWatchFacesBackgroundAlpha:1.0 exceptForPage:[self currentWatchFacePage]];
		
		[[LWCore sharedInstance] setCurrentWatchFace:[watchFaces objectAtIndex:currentWatchFaceIndex]];
		for (int i=0; i<watchFaces.count; i++) {
			[overlayView setTitleAlpha:(i == currentWatchFaceIndex ? 1.0 : 0.0) atIndex:i];
		}
		
		[[LWCore sharedInstance] startUpdatingTime];
	}
}

- (void)setIsSelecting:(BOOL)selecting editing:(BOOL)editing animated:(BOOL)animated didCancel:(BOOL)cancelled {
	if (isSelecting == selecting) {
		return;
	}
	
	[[LWCore sharedInstance] setIsEditing:editing];
	[[LWCore sharedInstance] setIsSelecting:selecting];
	[contentView setScrollEnabled:selecting];
	
	[tapGestureRecognizer setEnabled:(selecting && !editing)];
	[longPressGestureRecognizer setEnabled:(![self forceTouchCapable] && !selecting && !editing)];
	[self scrollViewDidScroll:contentView];
	
	if (selecting) {
		[[LWCore sharedInstance] stopUpdatingTime];
		[[self currentWatchFace] setIsEditing:NO];
		
		if (!isEditing) {
			AudioServicesPlaySystemSound(1520);
		}
		
		if (animated) {
			[UIView animateWithDuration:0.15 animations:^{
				[contentView setTransform:CGAffineTransformMakeScale(contentScale, contentScale)];
				[overlayView setTransform:CGAffineTransformIdentity];
				[overlayView setAlpha:1.0];
				
				[self setWatchFacePageAlpha:[self currentWatchFacePage] alpha:1.0];
				[self setWatchFaceBackgroundAlpha:[self currentWatchFacePage] alpha:1.0];
				[self setWatchFacePagesAlpha:0.5 exceptForPage:[self currentWatchFacePage]];
				[self setWatchFacesBackgroundAlpha:1.0 exceptForPage:[self currentWatchFacePage]];
				
				[overlayView.customizeButton setAlpha:([[self currentWatchFace] isCustomizable] ? 1 : 0)];
			}];
		}
		
		[[LWCore sharedInstance] setPreviousWatchFace:[[LWCore sharedInstance] currentWatchFace]];
		//[[LWCore sharedInstance] setCurrentWatchFace:nil];
	} else {
		void(^stopSelecting)() = ^{
			if (!cancelled) {
				[[LWCore sharedInstance] setCurrentWatchFace:[watchFaces objectAtIndex:[self currentPage]]];
				[[LWPreferences sharedInstance] setObject:[[[watchFaces objectAtIndex:[self currentPage]] watchFaceBundle] bundleIdentifier] forKey:@"selectedWatchFace"];
			}
			
			[UIView animateWithDuration:0.15 animations:^{
				[contentView setTransform:CGAffineTransformIdentity];
				[overlayView setTransform:CGAffineTransformMakeScale(overlayScale, overlayScale)];
				[overlayView setAlpha:0.0];
				
				[self setWatchFacePageAlpha:[self currentWatchFacePage] alpha:1.0];
				[self setWatchFaceBackgroundAlpha:[self currentWatchFacePage] alpha:0.0];
				[self setWatchFacePagesAlpha:0.0 exceptForPage:[self currentWatchFacePage]];
				[self setWatchFacesBackgroundAlpha:1.0 exceptForPage:[self currentWatchFacePage]];
			}];
			
			if (editing) {
				[[self currentWatchFace] setIsEditing:YES];
			} else {
				[[LWCore sharedInstance] startUpdatingTime];
				
				if ([[[LWCore sharedInstance] currentWatchFace] isKindOfClass:NSClassFromString(@"LWKDigitalClock")]) {
					[[LWCore sharedInstance] updateTimeForCurrentWatchFace];
					[[LWCore sharedInstance] updateTimeWhileTimeIsSyncing];
				} else {
					
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[[LWCore sharedInstance] updateTimeForCurrentWatchFace];
					});
				}
			}
		};
		
		int previous = (int)[watchFaces indexOfObject:[[LWCore sharedInstance] previousWatchFace]];
		
		if (cancelled && previous != [self currentPage]) {
			[UIView animateWithDuration:0.25 animations:^{
				[contentView setContentOffset:CGPointMake(previous * contentView.bounds.size.width, 0)];
			} completion:^(BOOL finished) {
				stopSelecting();
			}];
		} else {
			stopSelecting();
		}
	}
	
	isSelecting = selecting;
	isEditing = editing;
}

- (void)setWatchFacePageAlpha:(LWKPageView*)page alpha:(CGFloat)alpha {
	[page setAlpha:alpha];
}

- (void)setWatchFacePagesAlpha:(CGFloat)alpha exceptForPage:(LWKPageView*)page {
	for (LWKPageView* watchFacePage in watchFacePages) {
		if (page != watchFacePage) {
			[watchFacePage setAlpha:alpha];
		}
	}
}

- (void)setWatchFaceBackgroundAlpha:(LWKPageView*)page alpha:(CGFloat)alpha {
	[page setBackgroundAlpha:alpha];
}

- (void)setWatchFacesBackgroundAlpha:(CGFloat)alpha exceptForPage:(LWKPageView*)page {
	for (LWKPageView* watchFacePage in watchFacePages) {
		if (page != watchFacePage) {
			[watchFacePage setBackgroundAlpha:alpha];
		}
	}
}

#pragma mark Delegate Methods

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[contentView setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))];
	[overlayView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView* view = [super hitTest:point withEvent:event];
	
	
	if (view == overlayView && isSelecting) {
		return contentView;
	} else if (view == overlayView.customizeButton) {
		return view;
	}
	
	if (isSelecting) {
		return contentView;
	}
	
	if (isEditing) {
		return view;
	}
	
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
	[overlayView setContentOffset:CGPointMake(percent * overlayView.contentSize.width, 0)];
	
	CGFloat width = contentView.bounds.size.width;
	CGFloat pageProgress = (([self currentPage] * width) - scrollView.contentOffset.x) / width;
	pageProgress = (round(pageProgress * 100)) / 100.0;
	
	int page = (int)[self currentPage];
	int prevIndex = (page > 0) ? floor(page) : 0;
	int nextIndex = (page < watchFacePages.count - 1) ? ceil(page) : (int)watchFacePages.count - 1;
	
	if (lastScrollX != scrollView.contentOffset.x) {
		for (LWKPageView* page in watchFacePages) {
			[page setAlpha:(isSelecting ? 0.5 : 0.0)];
		}
		
		for (int i=0; i<watchFacePages.count; i++) {
			[overlayView setTitleAlpha:0 atIndex:i];
		}
		
		if (lastScrollX < scrollView.contentOffset.x) {
			LWKPageView* nextPage = [watchFacePages objectAtIndex:nextIndex];
			
			if (scrollView.contentOffset.x + width <= contentView.contentSize.width && scrollView.contentOffset.x > 0) {
				int currentIndex = MAX(nextIndex - 1, 0);
				LWKPageView* currentPage = [watchFacePages objectAtIndex:currentIndex];
				
				[currentPage setAlpha:MAX(0.5, pageProgress)];
				[nextPage setAlpha:MAX(0.5, 1 - pageProgress)];
				
				[overlayView setTitleAlpha:pageProgress atIndex:currentIndex];
				[overlayView setTitleAlpha:1 - pageProgress atIndex:nextIndex];
				
				if ([currentPage.watchFace isCustomizable]) {
					if ([nextPage.watchFace isCustomizable]) {
						[overlayView.customizeButton setAlpha:1];
					} else {
						[overlayView.customizeButton setAlpha:pageProgress];
					}
				} else {
					if ([nextPage.watchFace isCustomizable]) {
						[overlayView.customizeButton setAlpha:1 - pageProgress];
					} else {
						[overlayView.customizeButton setAlpha:0];
					}
				}
			} else if (scrollView.contentOffset.x <= 0) {
				LWKPageView* currentPage = [watchFacePages objectAtIndex:page];
				CGFloat alpha = MAX(0.5, 1 + (scrollView.contentOffset.x / width));
				
				[currentPage setAlpha:alpha];
				[overlayView setTitleAlpha:alpha atIndex:page];
				
				if ([currentPage.watchFace isCustomizable]) {
					[overlayView.customizeButton setAlpha:1 + (scrollView.contentOffset.x / width)];
				} else {
					[overlayView.customizeButton setAlpha:0];
				}
			} else {
				LWKPageView* currentPage = [watchFacePages objectAtIndex:page];
				CGFloat alpha = MAX(0.5, 1-((scrollView.contentOffset.x + width) - scrollView.contentSize.width) / width);
				
				[currentPage setAlpha:alpha];
				[overlayView setTitleAlpha:alpha atIndex:page];
				
				if ([currentPage.watchFace isCustomizable]) {
					[overlayView.customizeButton setAlpha:1 - ((scrollView.contentOffset.x + width) - scrollView.contentSize.width) / width];
				} else {
					[overlayView.customizeButton setAlpha:0];
				}
			}
		}
		
		if (lastScrollX > scrollView.contentOffset.x) {
			LWKPageView* prevPage = [watchFacePages objectAtIndex:prevIndex];
			
			if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x + width <= scrollView.contentSize.width) {
				int currentIndex = (int)MIN(prevIndex - 1, watchFacePages.count - 1);
				LWKPageView* currentPage = [watchFacePages objectAtIndex:currentIndex];
				
				[currentPage setAlpha:MAX(0.5, pageProgress)];
				[prevPage setAlpha:MAX(0.5, 1 - pageProgress)];
				
				[overlayView setTitleAlpha:pageProgress atIndex:currentIndex];
				[overlayView setTitleAlpha:1 - pageProgress atIndex:prevIndex];
				
				if ([currentPage.watchFace isCustomizable]) {
					if ([prevPage.watchFace isCustomizable]) {
						[overlayView.customizeButton setAlpha:1];
					} else {
						[overlayView.customizeButton setAlpha:pageProgress];
					}
				} else {
					if ([prevPage.watchFace isCustomizable]) {
						[overlayView.customizeButton setAlpha:1 - pageProgress];
					} else {
						[overlayView.customizeButton setAlpha:0];
					}
				}
			} else if (scrollView.contentOffset.x + width > scrollView.contentSize.width) {
				LWKPageView* currentPage = [watchFacePages objectAtIndex:page];
				CGFloat alpha = MAX(0.5, 1-((scrollView.contentOffset.x + width) - scrollView.contentSize.width) / width);
				
				[currentPage setAlpha:alpha];
				[overlayView setTitleAlpha:alpha atIndex:page];
				
				if ([currentPage.watchFace isCustomizable]) {
					[overlayView.customizeButton setAlpha:1 - ((scrollView.contentOffset.x + width) - scrollView.contentSize.width) / width];
				} else {
					[overlayView.customizeButton setAlpha:0];
				}
			} else {
				LWKPageView* currentPage = [watchFacePages objectAtIndex:page];
				CGFloat alpha = MAX(0.5, 1 + (scrollView.contentOffset.x / width));
				
				[currentPage setAlpha:alpha];
				[overlayView setTitleAlpha:alpha atIndex:page];
				
				if ([currentPage.watchFace isCustomizable]) {
					[overlayView.customizeButton setAlpha:1 + (scrollView.contentOffset.x / width)];
				} else {
					[overlayView.customizeButton setAlpha:0];
				}
			}
		}
	}
	
	lastScrollX = scrollView.contentOffset.x;
}

#pragma mark Touch/Force Handlers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	lastTouchX = 0.0;
	lastTouchY = 0.0;
	lastTouchForce = 0.0;
	
	if (event.type == UIEventTypeTouches && !isSelecting && [self forceTouchCapable]) {
		[self handleForce:touches];
	}
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (event.type == UIEventTypeTouches && [self forceTouchCapable]) {
		[self handleForce:touches];
	}
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	lastTouchX = 0.0;
	lastTouchY = 0.0;
	lastTouchForce = 0.0;
	
	if (!isSelecting) {
		[UIView animateWithDuration:0.15 animations:^{
			[contentView setTransform:CGAffineTransformIdentity];
			[overlayView setTransform:CGAffineTransformMakeScale(overlayScale, overlayScale)];
			[overlayView setAlpha:0.0];
		}];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if ([self forceTouchCapable]) {
		lastTouchForce = 0.0;
		
		[UIView animateWithDuration:0.15 animations:^{
			if (isSelecting) {
				[contentView setTransform:CGAffineTransformMakeScale(contentScale, contentScale)];
				[overlayView setTransform:CGAffineTransformIdentity];
				[overlayView setAlpha:1.0];
			} else {
				[contentView setTransform:CGAffineTransformIdentity];
				[overlayView setTransform:CGAffineTransformMakeScale(overlayScale, overlayScale)];
				[overlayView setAlpha:0.0];
				
				for (LWKPageView* page in watchFacePages) {
					if (page != [watchFacePages objectAtIndex:[self currentPage]]) {
						[page setAlpha:0.0];
					}
				}
				
				[[watchFacePages objectAtIndex:[self currentPage]] setAlpha:1.0];
				[[watchFacePages objectAtIndex:[self currentPage]] setBackgroundAlpha:0.0];
			}
		}];
	}
}

- (void)handleForce:(NSSet<UITouch*>*)touches {
	if (![self forceTouchCapable] || isEditing) {
		return;
	}
	
	UITouch* touch = [[touches allObjects] firstObject];
	CGFloat force = touch.force;
	
	if ([touch preciseLocationInView:self].x - lastTouchX != 0.0 || [touch preciseLocationInView:self].y - lastTouchY != 0.0) {
		force = lastTouchForce;
	} else {
		lastTouchForce = touch.force;
	}
	
	CGFloat forcePercentage = force / touch.maximumPossibleForce;
	CGFloat pressedScaleFactor = [LWMetrics pressedScale];
	CGFloat threshold = (1 - contentScale) * (1 / (1 - pressedScaleFactor));
	
	if (isSelecting) {
		forcePercentage = MAX(forcePercentage, threshold);
	}
	
	CGFloat _contentScale = 1 - (forcePercentage * (1 - pressedScaleFactor));
	CGFloat _overlayScale = overlayScale - ((overlayScale - 1) * ((1 - _contentScale) / (1 - contentScale)));
	CGFloat alpha = (1 - _contentScale) / (1 - contentScale);
	
	[contentView setTransform:CGAffineTransformMakeScale(_contentScale, _contentScale)];
	[overlayView setTransform:CGAffineTransformMakeScale(_overlayScale, _overlayScale)];
	[overlayView setAlpha:(isSelecting ? 1.0 : forcePercentage)];
	
	if (isSelecting) {
		[self setWatchFacePageAlpha:[self currentWatchFacePage] alpha:1.0];
		[self setWatchFaceBackgroundAlpha:[self currentWatchFacePage] alpha:1.0];
		[self setWatchFacePagesAlpha:0.5 exceptForPage:[self currentWatchFacePage]];
		[self setWatchFacesBackgroundAlpha:1.0 exceptForPage:[self currentWatchFacePage]];
		[overlayView.customizeButton setAlpha:([[self currentWatchFace] isCustomizable] ? 1.0 : 0)];
	} else {
		[self setWatchFacePageAlpha:[self currentWatchFacePage] alpha:1.0];
		[self setWatchFaceBackgroundAlpha:[self currentWatchFacePage] alpha:alpha];
		[self setWatchFacePagesAlpha:alpha/2 exceptForPage:[self currentWatchFacePage]];
		[self setWatchFacesBackgroundAlpha:1.0 exceptForPage:[self currentWatchFacePage]];
		[overlayView.customizeButton setAlpha:([[self currentWatchFace] isCustomizable] ? alpha : 0)];
	}
	
	if (forcePercentage >= threshold) {
		[self setIsSelecting:YES editing:NO animated:NO didCancel:NO];
	}
	
	[overlayView setContentOffset:CGPointMake((contentView.contentOffset.x / contentView.contentSize.width) * overlayView.contentSize.width, 0)];
	
	lastTouchX = [touch preciseLocationInView:self].x;
	lastTouchY = [touch preciseLocationInView:self].y;
}

#pragma mark Event Handlers

- (void)tapped {
	[self setIsSelecting:NO editing:NO animated:YES didCancel:NO];
}

- (void)pressed {
	[self setIsSelecting:YES editing:NO animated:YES didCancel:NO];
}

- (void)customizeButtonPressed {
	[self setIsSelecting:NO editing:YES animated:YES didCancel:NO];
}

#pragma mark Calculations

- (NSInteger)currentPage {
	return MAX(MIN(ceilf(contentView.contentOffset.x / contentView.bounds.size.width), watchFaces.count-1), 0);
}

- (LWKClockBase*)currentWatchFace {
	return [watchFaces objectAtIndex:[self currentPage]];
}

- (LWKPageView*)currentWatchFacePage {
	return [watchFacePages objectAtIndex:[self currentPage]];
}

#pragma mark Capabilities

- (BOOL)forceTouchCapable {
	return ((self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) || [[UIDevice currentDevice] _supportsForceTouch]) && !DISABLE_FORCE_TOUCH;
}

@end
