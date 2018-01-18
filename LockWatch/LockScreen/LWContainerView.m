#import "LockWatch.h"

@implementation LWContainerView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_interfaceView = [[LWInterfaceView alloc] initWithFrame:CGRectMake(0, screenHeight/2 - [LWMetrics watchHeight]/2, frame.size.width, [LWMetrics watchHeight])];
		[_interfaceView setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))];
		[self addSubview:_interfaceView];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[_interfaceView setFrame:CGRectMake(0, screenHeight/2 - [LWMetrics watchHeight]/2, frame.size.width, [LWMetrics watchHeight])];
	//[_interfaceView setCenter:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))];
}

@end

