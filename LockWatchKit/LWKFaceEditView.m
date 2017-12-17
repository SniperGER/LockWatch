#import "LWKFaceEditView.h"
#import "LWKFaceEditPageView.h"

@implementation LWKFaceEditView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		editScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		[self addSubview:editScrollView];
	}
	
	return self;
}

- (void)addCustomizationOptionsForArray:(NSArray*)array {
	for (int i=0; i<array.count; i++) {
		LWKFaceEditPageView* page = [[LWKFaceEditPageView alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:array[i]];
		[editScrollView addSubview:page];
	}
	
	[editScrollView setContentSize:CGSizeMake(array.count * 312, 390)];
}

- (int)currentPage {
	return 0;
}

@end
