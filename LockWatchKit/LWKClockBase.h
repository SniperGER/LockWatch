#import <UIKit/UIKit.h>

@interface LWKClockBase : NSObject {
	NSTimer* clockUpdateTimer;
}

@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* clockView;
@property (nonatomic, assign) BOOL isCustomizable;

- (void)didStartUpdatingTime;
- (void)didStopUpdatingTime;
- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated;
- (void)prepareForInit;

@end
