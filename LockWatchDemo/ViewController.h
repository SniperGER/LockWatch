#import <UIKit/UIKit.h>

@class LWPreferences, LWCore;

@interface ViewController : UIViewController {
	IBOutlet UISwitch* watchSizeSwitch;
	IBOutlet UILabel* watchSizeLabel;

	LWPreferences* preferences;
	LWCore* lockwatch;
}


@end

