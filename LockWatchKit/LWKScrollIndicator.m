#import "LWKScrollIndicator.h"

@implementation LWKScrollIndicator

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
		[self.layer setCornerRadius:6.0];
		
		innerView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
		[innerView setBackgroundColor:[UIColor colorWithRed:0.02 green:0.87 blue:0.44 alpha:1.0]];
		[innerView.layer setCornerRadius:4.0];
		[self addSubview:innerView];
		
		indicatorHeight = 71;
	}
	
	return self;
}

- (void)setIndicatorHeight:(CGFloat)height relativeToHeight:(CGFloat)relativeHeight {
	indicatorScale = (relativeHeight / height);
	indicatorHeight = MAX(71 * indicatorScale, 12);
	[innerView setFrame:CGRectMake(2, 2, 8, indicatorHeight)];
}

- (void)setIndicatorPosition:(CGFloat)percentage {
	percentage = MAX(MIN(percentage, 1), 0);
	
	CGFloat height = 71 - indicatorHeight;
	[innerView setFrame:CGRectMake(2, 2 + (height*percentage), 8, indicatorHeight)];
}

@end
