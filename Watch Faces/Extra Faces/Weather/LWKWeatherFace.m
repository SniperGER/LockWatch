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
		
		cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 35)];
		[cityView setCenter:CGPointMake(156, 195 + 156 + 27.0)];
		[cityView.layer setCornerRadius:17.5];
		[cityView setClipsToBounds:YES];
		[self.backgroundView addSubview:cityView];
		
		_UIBackdropView* cityBackground = [[_UIBackdropView alloc] initWithFrame:CGRectMake(0, 0, 312, 35) autosizesToFitSuperview:NO settings:[_UIBackdropViewSettings settingsForStyle:1]];
		[cityView addSubview:cityBackground];
		
		cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 312, 35)];
		[cityLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Regular" size:27]];
		[cityLabel setTextColor:[UIColor whiteColor]];
		[cityLabel setTextAlignment:NSTextAlignmentCenter];
		[cityLabel setText:[[self.watchFaceBundle localizedInfoDictionary][@"CFBundleDisplayName"] uppercaseString]];
		[cityView addSubview:cityLabel];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	currentHour = hour;
	
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
	
	if (minute >= 15) {
		hourPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(102, 102) radius:86 startAngle:deg2rad(-90 + (hourValue*360)) endAngle:deg2rad(-90 + ((hour+1)*30) + 300) clockwise:YES];
	}
	
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
	
	NSArray* indicatorLabelStrings = [[[NSBundle bundleForClass:self.class] localizedStringForKey:@"HOUR_LABELS" value:@"" table:nil] componentsSeparatedByString:@" "];
	for (int i=0; i<12; i++) {
		UILabel* label = indicatorLabels[(int)(hour + i) % 12];
	
		[label setText:[NSString stringWithFormat:@"%@", indicatorLabelStrings[(currentHour + i) % indicatorLabelStrings.count]]];
		[label sizeToFit];
		
		CGFloat posX = sin(deg2rad((hour + i) * 30)) * 86;
		CGFloat posY = cos(deg2rad((hour + i) * 30)) * 86;
		[label setCenter:CGPointMake(156 + posX, 195 - posY)];
	}
	
	[[indicatorLabels objectAtIndex:hour] setTextColor:[UIColor blackColor]];
	[[indicatorLabels objectAtIndex:hour] setHidden:(minute >= 15)];
	[[indicatorLabels objectAtIndex:(hour+11 < 12 ? hour+11 : hour-1)] setHidden:(minute < 15)];
	
	[[weatherIcons objectAtIndex:hour] setHidden:(minute >= 15)];
	[[weatherIcons objectAtIndex:(hour+11 < 12 ? hour+11 : hour-1)] setHidden:(minute < 15)];
}

- (void)didStartUpdatingTime {
	[super didStartUpdatingTime];
	
	[self updateWeatherData];
}

- (void)didStopUpdatingTime {
	[super didStopUpdatingTime];
}

- (void)updateWeatherData {
	City* currentCity = [LWKWeatherDataProvider currentCity];
	
	if (!currentCity.cityUpdateObservers) {
		currentCity.cityUpdateObservers = [[NSHashTable alloc] init];
		[currentCity.cityUpdateObservers addObject:self];
	} else {
		if (![currentCity.cityUpdateObservers containsObject:self]) {
			[currentCity.cityUpdateObservers addObject:self];
		}
	}
	[currentCity update];
}

- (void)cityDidStartWeatherUpdate:(id)arg1 {
	NSLog(@"[LockWatch | Weather] start weather update");
}

- (void)cityDidFinishWeatherUpdate:(City*)arg1 {
	[cityLabel setText:[[arg1 name] uppercaseString]];
	
	[temperatureLabel setText:[NSString stringWithFormat:@"%d", (int)[LWKWeatherDataProvider currentTemperatureForCity:arg1]]];
	[temperatureLabel sizeToFit];
	[temperatureLabel setCenter:CGPointMake(156, 195)];
	[temperatureLabel setText:[NSString stringWithFormat:@"%@°", temperatureLabel.text]];
	[temperatureLabel sizeToFit];
	
	NSArray* forecasts = [arg1 hourlyForecasts];
	for (int i=0; i<12; i++) {
		WAHourlyForecast* forecast = [forecasts objectAtIndex:i];
		UIImageView* conditionImage = [weatherIcons objectAtIndex:(int)(currentHour + forecast.hourIndex) % 12];
		[conditionImage setImage:[UIImage imageNamed:[WeatherIcons imageForConditionCode:forecast.conditionCode atHour:currentHour] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
	}
}

@end
