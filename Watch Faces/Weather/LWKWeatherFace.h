#import <LockWatchKit/LockWatchKit.h>

@interface LWKWeatherFace : LWKDigitalClock {
	UILabel* temperatureLabel;
	
	CAShapeLayer* hourThing;
	UIView* hourIndicator;
	
	NSMutableArray<UILabel*>* indicatorLabels;
	NSMutableArray<UIImageView*>* weatherIcons;
}

@end
