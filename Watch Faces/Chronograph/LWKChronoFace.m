#import "LWKChronoFace.h"

@implementation LWKChronoFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.indicatorView insertSubview:self.dateLabel atIndex:0];
		[self updateDateLabel];
		
		indicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chronograph" inBundle:self.watchFaceBundle compatibleWithTraitCollection:nil]];
		[indicatorImage setCenter:CGPointMake(156, 195)];
		
		[self.hourHand setImage:[UIImage imageNamed:@"chrono_hour" inBundle:self.watchFaceBundle compatibleWithTraitCollection:nil]];
		
		[self.minuteHand setImage:[UIImage imageNamed:@"chrono_minute" inBundle:self.watchFaceBundle compatibleWithTraitCollection:nil]];
		
		[self.secondHand removeFromSuperview];
		self.secondHand = [[LWKClockHand alloc] initWithImage:[[UIImage imageNamed:@"chrono_indicator" inBundle:self.watchFaceBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		[self.secondHand setTintColor:[UIColor whiteColor]];
		[self.secondHand setFrame:CGRectMake(0, 0, 6, 47)];
		[self.secondHand.layer setAnchorPoint:CGPointMake(0.5, 88.0/94.0)];
		[self.secondHand.layer setPosition:CGPointMake(156, 213)];
		[self.indicatorView insertSubview:self.secondHand atIndex:0];
		
		chronoStopwatchSeconds = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"second" inBundle:[NSBundle bundleForClass:[LWKClockBase class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		[chronoStopwatchSeconds setTintColor:[UIColor colorWithRed:1.0 green:0.584 blue:0.0 alpha:1.0]];
		[chronoStopwatchSeconds.layer setAnchorPoint:CGPointMake(0.5, 311.0/362.0)];
		[chronoStopwatchSeconds.layer setPosition:CGPointMake(156, 156)];
		[self.indicatorView addSubview:chronoStopwatchSeconds];
		
		[self.contentView addSubview:indicatorImage];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	[super updateForHour:hour minute:minute second:second millisecond:msecond animated:animated];
	
	[self updateDateLabel];
}

#pragma mark Additional Methods

- (void)updateDateLabel {
	NSDate* date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];

	long day = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:date];
	
	NSString* dateString = [NSString stringWithFormat:@"%ld", day];
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:dateString];

	[attributedText setAttributes:@{
									NSForegroundColorAttributeName:[WatchColors lightOrangeColor],
									NSFontAttributeName: [UIFont fontWithName:@".SFCompactText-Regular" size:30]
									} range:[dateString rangeOfString:[NSString stringWithFormat:@"%ld", day]]];
	[self.dateLabel setAttributedText:attributedText];
	[self.dateLabel sizeToFit];
	[self.dateLabel setCenter:CGPointMake(239.5, 156)];
}

@end