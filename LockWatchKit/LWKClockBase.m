#import "LWKClockBase.h"

@implementation LWKClockBase

- (id)init {
	if (self = [super init]) {
		self.clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		
		[self.clockView addSubview:self.backgroundView];
		[self.clockView addSubview:self.contentView];
		
		[self prepareCustomizationMode];
	}
	
	return self;
}

- (void)updateForHour:(double)hour minute:(double)minute second:(double)second millisecond:(double)msecond animated:(BOOL)animated {
	
}

- (void)prepareForInit {
	[self updateForHour:10 minute:9 second:30 millisecond:0 animated:NO];
}

- (void)prepareCustomizationMode {
	NSDictionary* customizationOptions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"Customization" ofType:@"plist"]];
	
	if (customizationOptions) {
		self.isCustomizable = YES;
	}
}

- (void)didStartUpdatingTime {}
- (void)didStopUpdatingTime {}

@end
