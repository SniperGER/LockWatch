#import "LWKComplicationCustomizationSelector.h"
#import "LWKFaceEditView.h"
#import "LWKScrollIndicator.h"
#import "LWKClockBase.h"
#import "LWKLabel.h"

@implementation LWKComplicationCustomizationSelector

- (id)initWithFrame:(CGRect)frame options:(NSDictionary *)options forWatchFace:(LWKClockBase *)watchFace faceEditView:(LWKFaceEditView *)faceEditView {
	if (self = [super initWithFrame:frame]) {
		customizingOptions = options;
		customizingWatchFace = watchFace;
		customizingFaceEditView = faceEditView;
		
		complicationOptions = [NSMutableArray new];
		for (int i=0; i<[options[@"options"] count]; i++) {
			NSDictionary* complicationOption = options[@"options"][i];
			
			if (complicationOption[@"frame"]) {
				UIView* complicationView = [[UIView alloc] initWithFrame:CGRectFromString(complicationOption[@"frame"])];
				[complicationView.layer setBorderWidth:2];
				[complicationView.layer setBorderColor:[UIColor colorWithRed:0.02 green:0.87 blue:0.44 alpha:1.0].CGColor];
				
				if (complicationOption[@"cornerRadius"]) {
					[complicationView.layer setCornerRadius:[complicationOption[@"cornerRadius"] floatValue]];
				}
				
				if (complicationOption[@"label"]) {
					labelView = [[LWKLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
					[labelView setText:[[[NSBundle bundleForClass:self.class] localizedStringForKey:complicationOption[@"label"][@"text"] value:@"" table:nil] uppercaseString]];
					[labelView setCenter:CGPointFromString(complicationOption[@"label"][@"center"])];
					[self addSubview:labelView];
					
					if (complicationOption[@"label"][@"align"]) {
						CGRect labelFrame = labelView.frame;
						if ([complicationOption[@"label"][@"align"] isEqualToString:@"left"]) {
							labelFrame.origin.x = complicationView.frame.origin.x;
						} else if ([complicationOption[@"label"][@"align"] isEqualToString:@"right"]) {
							labelFrame.origin.x = complicationView.bounds.size.width - labelFrame.size.width;
						} else if ([complicationOption[@"label"][@"align"] isEqualToString:@"center"]) {
							labelFrame.origin.x = (complicationView.frame.origin.x + (complicationView.bounds.size.width / 2)) - labelFrame.size.width / 2;
						}
						[labelView setFrame:labelFrame];
					}
				}
				
				UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(complicationOptionTapped:)];
				[complicationView addGestureRecognizer:tap];
				
				[complicationOptions addObject:complicationView];
				[self addSubview:complicationView];
			}
		}
		
		contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 400)];
		[contentScrollView setDelegate:self];
		[contentScrollView setPagingEnabled:YES];
		[contentScrollView setShowsHorizontalScrollIndicator:NO];
		[contentScrollView setShowsVerticalScrollIndicator:NO];
		[self addSubview:contentScrollView];
		
		if (complicationOptions.count > 0) {
			selectedComplicationView = complicationOptions[0];
			
			[contentScrollView setDelegate:nil];
			[contentScrollView setContentOffset:CGPointMake(0, [customizingWatchFace complicationIndexForPosition:options[@"options"][0][@"position"]] * 400)];
			[contentScrollView setContentSize:CGSizeMake(0, [self indicatorHeight])];
			[contentScrollView setDelegate:self];
		}
	}
	
	return self;
}

- (NSString*)type {
	return @"complications";
}

- (CGFloat)indicatorHeight {
	int index = (int)[complicationOptions indexOfObject:selectedComplicationView];
	return [customizingOptions[@"options"][index][@"options"] count] * 400;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat page = (scrollView.contentOffset.y / scrollView.bounds.size.height);
	CGFloat pageProgress = 1 + (page - (int)page - 1);
	
	if (pageProgress < 0.5) {
		page = floorf(page);
	} else {
		page = ceilf(page);
	}
	
	NSString* complicationPosition = customizingOptions[@"options"][[self indexForCurrentComplicationSelector]][@"position"];
	[customizingWatchFace setComplicationIndex:page forPosition:complicationPosition];
	
	lastScrollY = scrollView.contentOffset.y;
	[[customizingFaceEditView scrollIndicator] setIndicatorPosition:[self indicatorPosition]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {}

- (void)complicationOptionTapped:(UITapGestureRecognizer*)sender {
	selectedComplicationView = sender.view;
	[contentScrollView setContentSize:CGSizeMake(0, [self indicatorHeight])];
	[customizingFaceEditView scrollViewDidScroll:customizingFaceEditView.scrollView];
}

- (int)indexForCurrentComplicationSelector {
	return (int)[complicationOptions indexOfObject:selectedComplicationView];
}

@end
