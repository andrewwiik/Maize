#import "MZEAnimatedBlurView.h"
#import "MZEMaterialView.h"

@interface MZEBackgroundView : UIView {
	MZEAnimatedBlurView *_blurView;
	MZEMaterialView *_luminanceView;
	CGFloat _effectProgress;
}

@property (nonatomic, retain, readwrite) MZEAnimatedBlurView *blurView;
@property (nonatomic, retain, readwrite) MZEMaterialView *luminanceView;
@property (nonatomic, assign) CGFloat effectProgress;
- (id)initWithFrame:(CGRect)frame;
- (void)setEffectProgress:(CGFloat)effectProgress;
@end