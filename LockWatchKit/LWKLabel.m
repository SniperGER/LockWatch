#import "LWKLabel.h"

@implementation LWKLabel

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
			[self setBackgroundColor:[UIColor colorWithRed:0.42 green:0.85 blue:0.49 alpha:1.0]];
			[self setClipsToBounds:YES];
			[self.layer setCornerRadius:6];
			
			textLabel = [[UILabel alloc] initWithFrame:self.bounds];
			[textLabel setFont:[UIFont fontWithName:@".SFCompactText-Heavy" size:20]];
			[textLabel setTextAlignment:NSTextAlignmentCenter];
			[self addSubview:textLabel];
	}
	
	return self;
}

- (void)setText:(NSString *)text {
	[textLabel setText:text];
	[self updateFrame];
}

- (void)updateFrame {
	// 5, 1.5
	[textLabel sizeToFit];
	
	CGRect labelFrame = CGRectInset(textLabel.frame, -2.5, -.75);
	CGPoint currentCenter = self.center;
	
	CGRect wrapperFrame = self.frame;
	wrapperFrame.size.width = labelFrame.size.width;
	wrapperFrame.size.height = labelFrame.size.height;
	[self setFrame:wrapperFrame];
	[self setCenter:currentCenter];
	
	[textLabel setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
}

@end
