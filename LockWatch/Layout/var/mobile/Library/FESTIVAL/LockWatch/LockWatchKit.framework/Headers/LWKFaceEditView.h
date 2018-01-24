#import <UIKit/UIKit.h>

@class LWKFaceEditPageView, LWKScrollIndicator, LWKClockBase;

@interface LWKFaceEditView : UIView <UIScrollViewDelegate> {
	UIPageControl* pageIndicator;
	NSMutableArray* pages;
	CGFloat lastScrollX;
	LWKClockBase* customizingWatchFace;
}

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) LWKScrollIndicator* scrollIndicator;

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWKClockBase*)watchFace;
- (NSArray*)pages;

@end
