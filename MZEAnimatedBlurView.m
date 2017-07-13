
#import "MZEAnimatedBlurView.h"

@implementation MZEAnimatedBlurView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_UIBackdropViewSettings *defaultSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
		self.backdropSettings = defaultSettings;
		self.backdropView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:defaultSettings];
		[self.backdropView setAppliesOutputSettingsAnimationDuration:0.25];
		_progress = 0.0f;

	}
	return self;
}

- (void)layoutSubviews {
	if (![self.backdropView superview]) {

		self.backdropView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:self.backdropView];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backdropView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	}
	[super layoutSubviews];
}

- (CGFloat)progress {
	return _progress;
}

- (void)setProgress:(CGFloat)desiredProgress {
	if (desiredProgress >= 0) {
		[self.backdropView transitionIncrementallyToSettings:self.backdropSettings weighting:desiredProgress];
		if (self.backdropView.colorSaturateFilter) {
			[self.backdropView.colorSaturateFilter setValue:[NSNumber numberWithFloat:self.backdropSettings.saturationDeltaFactor*desiredProgress] forKey:@"inputAmount"];
		}
		_progress = desiredProgress;
	}
}
@end