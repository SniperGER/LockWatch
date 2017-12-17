#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@class LWKPageView, LWKClockBase, LWFaceLibraryOverlayView;

@interface LWScrollView : UIView <UIScrollViewDelegate> {
	UIScrollView* contentView;
	NSMutableArray<LWKPageView*>* watchFacePages;
	NSMutableArray<LWKClockBase*>* watchFaces;
	
	LWFaceLibraryOverlayView* overlayView;
	
	UITapGestureRecognizer* tapGestureRecognizer;
	UILongPressGestureRecognizer* longPressGestureRecognizer;
	BOOL isSelecting;
	BOOL isEditing;
	
	CGFloat lastTouchX;
	CGFloat lastTouchY;
	CGFloat lastTouchForce;
	CGFloat lastScrollX;
}

- (void)setIsSelecting:(BOOL)selecting editing:(BOOL)editing animated:(BOOL)animated;

@end

@interface UIDevice (Private)

- (BOOL)_supportsForceTouch;

@end
