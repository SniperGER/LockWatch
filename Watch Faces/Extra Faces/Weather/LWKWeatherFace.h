#import <LockWatchKit/LockWatchKit.h>

@interface LWKWeatherFace : LWKDigitalClock <CityUpdateObserver> {
	UILabel* temperatureLabel;
	
	int currentHour;
	CAShapeLayer* hourThing;
	UIView* hourIndicator;
	
	UIView* cityView;
	UILabel* cityLabel;
	
	NSMutableArray<UILabel*>* indicatorLabels;
	NSMutableArray<UIImageView*>* weatherIcons;
}

@end
