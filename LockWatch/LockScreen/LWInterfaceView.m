#import "LockWatch.h"

@implementation LWInterfaceView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		_scrollView = [[LWScrollView alloc] initWithFrame:self.bounds];
		[self addSubview:_scrollView];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[_scrollView setFrame:self.bounds];
}

@end
