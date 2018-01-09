#import "LWKWeatherFace.h"

@implementation LWKWeatherFace

- (id)init {
	if (self = [super init]) {
		_UIBackdropView* backgroundView = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 312) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[backgroundView.layer setPosition:CGPointMake(156, 195)];
		[backgroundView.layer setCornerRadius:156.0];
		[backgroundView setClipsToBounds:YES];
		[self.backgroundView insertSubview:backgroundView atIndex:0];
		
		temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[temperatureLabel setFont:[UIFont fontWithName:@".SFCompactText-Medium" size:76]];
		[temperatureLabel setTextColor:[UIColor whiteColor]];
		[temperatureLabel setTextAlignment:NSTextAlignmentCenter];
		[temperatureLabel setText:@"--"];
		[temperatureLabel sizeToFit];
		[temperatureLabel setCenter:CGPointMake(156, 195)];
		[self.contentView addSubview:temperatureLabel];
		
		UIView* hourView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 204, 204)];
		[hourView setCenter:CGPointMake(156, 195)];
		
		hourThing = [CAShapeLayer layer];
		[hourThing setLineWidth:32];
		[hourThing setFillColor:[UIColor clearColor].CGColor];
		[hourThing setStrokeColor:[UIColor colorWithWhite:0.15 alpha:1.0].CGColor];
		[hourThing setLineCap:kCALineCapRound];
		[hourView.layer addSublayer:hourThing];
		
		[self.backgroundView addSubview:hourView];
		
		hourIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
		[hourIndicator setBackgroundColor:[UIColor colorWithRed:0.2 green:0.81 blue:0.97 alpha:1.0]];
		[hourIndicator.layer setCornerRadius:17];
		[self.contentView addSubview:hourIndicator];
		
		indicatorLabels = [NSMutableArray new];
		for (int i=0; i<12; i++) {
			UILabel* indicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[indicatorLabel setFont:[UIFont fontWithName:@".SFCompactText-Medium" size:18]];
			[indicatorLabel setTextColor:[UIColor whiteColor]];
			[indicatorLabel setText:[NSString stringWithFormat:@"%02d", i]];
			[indicatorLabel sizeToFit];
			
			CGFloat posX = sin(deg2rad(i * 30)) * 86;
			CGFloat posY = cos(deg2rad(i * 30)) * 86;
			[indicatorLabel setCenter:CGPointMake(156 + posX, 195 - posY)];
			
			[self.contentView addSubview:indicatorLabel];
			[indicatorLabels addObject:indicatorLabel];
		}
		
		weatherIcons = [NSMutableArray new];
		for (int i=0; i<12; i++) {
			UIImageView* weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
			[weatherIcon setImage:[UIImage imageNamed:@"no_report-nc_100x100_" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
			
			CGFloat posX = sin(deg2rad(i * 30)) * 129;
			CGFloat posY = cos(deg2rad(i * 30)) * 129;
			[weatherIcon setCenter:CGPointMake(156 + posX, 195 - posY)];
			
			[self.contentView addSubview:weatherIcon];
			[weatherIcons addObject:weatherIcon];
		}
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	if (minute <= 15) {
		minute = 0;
	} else if (minute < 45) {
		minute = 30;
	} else {
		minute = 0;
		hour = (hour == 23 ? 0 : hour+1);
	}
	
	if (hour >= 12) {
		hour -= 12;
	}
	
	float minuteValue = (minute/60);
	float hourValue = (hour/12) + (minuteValue/12);
	
		UIBezierPath* hourPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(102, 102) radius:86 startAngle:deg2rad(-90 + (hourValue*360)) endAngle:deg2rad(-90 + (hour*30) + 300) clockwise:YES];
		[hourThing setPath:hourPath.CGPath];
		
		CGFloat posX = sin(deg2rad(hourValue * 360)) * 86;
		CGFloat posY = cos(deg2rad(hourValue * 360)) * 86;
		[hourIndicator setCenter:CGPointMake(156 + posX, 195 - posY)];
		
	for (UILabel* label in indicatorLabels) {
		[label setHidden:NO];
		[label setTextColor:[UIColor whiteColor]];
	}
	for (UIImageView* image in weatherIcons) {
		[image setHidden:NO];
	}
	
	[[indicatorLabels objectAtIndex:hour] setTextColor:[UIColor blackColor]];
	[[indicatorLabels objectAtIndex:hour] setHidden:(minute >= 15)];
	[[indicatorLabels objectAtIndex:(hour+11 < 12 ? hour+11 : hour-1)] setHidden:YES];
	
	[[weatherIcons objectAtIndex:hour] setHidden:(minute >= 15)];
	[[weatherIcons objectAtIndex:(hour+11 < 12 ? hour+11 : hour-1)] setHidden:YES];
}

@end
