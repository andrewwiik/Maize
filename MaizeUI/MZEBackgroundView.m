#import "MZEBackgroundView.h"
#import <UIKit/_UIBackdropViewSettings+Private.h>
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CABackdropLayer.h>

@implementation MZEBackgroundView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_effectProgress = 0.0f;

		_luminanceView = [[MZEMaterialView alloc] init];
		_luminanceView.luminanceAlpha = 1.0f;
		//_luminanceView.saturation = 1.9f;
		_luminanceView.alpha = 0;
		_luminanceView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self addSubview:_luminanceView];

		_blurView = [[MZEAnimatedBlurView alloc] initWithFrame:[self bounds]];
	  	_blurView.backdropSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
	  	_blurView.backdropSettings.blurRadius = 30.0f;
	  	_blurView.backdropSettings.saturationDeltaFactor = 1.9f;
	    _blurView.backdropSettings.grayscaleTintAlpha = 0;
	    _blurView.backdropSettings.colorTintAlpha = 0;
	    _blurView.backdropSettings.grayscaleTintLevel = 0;
	    _blurView.backdropSettings.usesGrayscaleTintView = NO;
	    _blurView.backdropSettings.usesColorTintView = NO;
	    _blurView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	    [self addSubview:_blurView];
	}
	return self;
}

- (void)layoutSubviews {
	if (_luminanceView) {
		_luminanceView.frame = self.bounds;
	}
	if (_blurView) {
		_blurView.frame = self.bounds;
	}
}

- (void)setEffectProgress:(CGFloat)progress {
	if (progress != _effectProgress) {
		_effectProgress = progress;
		if (progress < 0.25) {
			if (((CABackdropLayer *)_blurView.backdropView.effectView.layer).scale == 0.25) {
				((CABackdropLayer *)_blurView.backdropView.effectView.layer).scale = 1;
				((CABackdropLayer *)_luminanceView.backdropView.layer).scale = 1.0;
			}
		} else {
			if (((CABackdropLayer *)_blurView.backdropView.effectView.layer).scale == 1.0) {
				((CABackdropLayer *)_blurView.backdropView.effectView.layer).scale = 0.25;
				((CABackdropLayer *)_luminanceView.backdropView.layer).scale = 0.25;
			}
		}
		[UIView animateWithDuration:0.00 animations:^{
			_luminanceView.alpha = progress*0.45;
			_blurView.progress = progress;
		//_animator.fractionComplete = progress;
		} completion:nil];
	}
}
@end