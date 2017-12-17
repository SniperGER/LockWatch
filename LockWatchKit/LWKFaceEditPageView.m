#import "LWKFaceEditPageView.h"

@implementation LWKFaceEditPageView

- (id)initWithFrame:(CGRect)frame options:(NSDictionary*)options {
	if (self = [super initWithFrame:frame]) {
		if ([options[@"type"] isEqualToString:@"style"]) {
			UIView* borderView = [[UIView alloc] initWithFrame:CGRectFromString(options[@"frame"])];
			[borderView.layer setCornerRadius:[options[@"cornerRadius"] floatValue]];
			[borderView.layer setBorderWidth:3];
			[borderView.layer setBorderColor:[UIColor colorWithRed:0.42 green:0.85 blue:0.49 alpha:1.0].CGColor];
			[self addSubview:borderView];
			
			if (options[@"label"]) {
				UIView* labelView = [[UIView alloc] initWithFrame:CGRectFromString(options[@"label"][@"frame"])];
				[labelView setBackgroundColor:[UIColor colorWithRed:0.42 green:0.85 blue:0.49 alpha:1.0]];
				[labelView setClipsToBounds:YES];
				[labelView.layer setCornerRadius:6];
				[self addSubview:labelView];
				
				UILabel* label = [[UILabel alloc] initWithFrame:labelView.bounds];
				[label setFont:[UIFont fontWithName:@".SFCompactText-Heavy" size:20]];
				[label setTextAlignment:NSTextAlignmentCenter];
				[label setText:options[@"label"][@"text"]];
				[labelView addSubview:label];
			}
		}
	}
	
	return self;
}

@end
