#import <UIKit/UIKit.h>

@class LWFaceLibraryCustomizeButton;

@interface LWFaceLibraryOverlayView : UIView {
	NSMutableArray* titles;
	UIScrollView* titleView;
}

@property (nonatomic, strong) LWFaceLibraryCustomizeButton* customizeButton;

- (void)addTitle:(NSString*)title;
- (void)setTitleAlpha:(CGFloat)alpha atIndex:(NSInteger)index;
- (void)resetTitles;
- (CGSize)contentSize;
- (void)setContentSize:(CGSize)contentSize;
- (CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset;

@end
