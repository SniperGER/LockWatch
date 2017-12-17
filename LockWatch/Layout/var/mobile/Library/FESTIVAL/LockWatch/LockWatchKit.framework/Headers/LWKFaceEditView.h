#import <UIKit/UIKit.h>

@interface LWKFaceEditView : UIView {
	UIScrollView* editScrollView;
}

- (void)addCustomizationOptionsForArray:(NSArray*)array;
- (int)currentPage;

@end
