@interface NCMaterialSettings : NSObject

@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, assign) CGFloat ccWhiteOverlayAlpha;
@property (nonatomic, assign) CGFloat cutOutOverlayAlpha;
@property (nonatomic, assign) CGFloat cutOutOverlayWhite;
@property (nonatomic, assign) CGFloat darkenedWhiteAlpha;
@property (nonatomic, assign) CGFloat lightOverlayAlpha;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat overlayalpha;
@property (nonatomic, assign) CGFloat whiteAlpha;
@property (nonatomic, assign) CGFloat whiteOverlayAlpha;

@end

@interface NCMaterialView : UIView

+(id)materialViewWithStyleOptions:(unsigned long long)arg1 ;
-(void)setCornerRadius:(double)arg1 ;

@end
