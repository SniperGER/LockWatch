#import <UIKit/UIKit.h>

@class LWKClockBase, LWKFaceEditView, LWKLabel;

@interface LWKCustomizationSelector : UIView <UIScrollViewDelegate> {
	NSDictionary* customizingOptions;
	LWKClockBase* customizingWatchFace;
	LWKFaceEditView* customizingFaceEditView;
	UIScrollView* contentScrollView;
	
	UIView* borderView;
	LWKLabel* labelView;
	
	CGFloat lastScrollY;
}

- (id)initWithFrame:(CGRect)frame options:(NSDictionary*)options forWatchFace:(LWKClockBase*)watchFace faceEditView:(LWKFaceEditView*)faceEditView;
- (NSString*)type;
- (CGFloat)indicatorHeight;
- (CGFloat)indicatorPosition;

- (void)handleSwipeRightToLeft:(CGFloat)scrollProgress isNext:(BOOL)next;
- (void)handleSwipeLeftToRight:(CGFloat)scrollProgress isPrev:(BOOL)prev;

@end
