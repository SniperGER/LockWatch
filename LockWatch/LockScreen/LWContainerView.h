#import <UIKit/UIKit.h>

@interface LWContainerView : UIView {
	IBOutlet UIView* notificationView;
	IBOutlet UIView* mediaArtworkView;
}

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* notificationWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* mediaArtworkWidth;

@end
