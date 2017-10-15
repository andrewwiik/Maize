#import "MZEContentModuleBackgroundView.h"
#import <QuartzCore/CALayer+Private.h>
#import <UIKit/UIView+Private.h>

static BOOL isIOS11Mode = YES;

@implementation MZEContentModuleBackgroundView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setAlpha:0];
		[[self layer] setHitTestsAsOpaque:YES];

		if (!isIOS11Mode) {
			_hybridBackgroundView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithStyle:-2];
			_hybridBackgroundView.appliesOutputSettingsAnimationDuration = 0.3;
			//_hybridBackgroundView.hidden = YES;
			[self addSubview:_hybridBackgroundView];
			_hybridTintingView = [[UIView alloc] initWithFrame:self.bounds];
			_hybridTintingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
			_hybridTintingView.alpha = 0.0;
			_hybridTintingView.layer.compositingFilter = @"plusD";
			[_hybridTintingView _setDrawsAsBackdropOverlayWithBlendMode:1];
			[self addSubview:_hybridTintingView];
		}
	}
	return self;
}

- (void)setAlpha:(CGFloat)alpha {
	if (!isIOS11Mode) {
		for (UIView *view in [self subviews]) {
			if (view != _hybridTintingView && view != _hybridBackgroundView) {
				view.alpha = alpha;
			}
			//view.frame = self.bounds;
		}
	} else {
		[super setAlpha:alpha];
	}
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
	[super setUserInteractionEnabled:enabled];
	[[self layer] setHitTestsAsOpaque:enabled == NO];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	for (UIView *view in [self subviews]) {
		view.frame = self.bounds;
	}
}

- (void)transitionToExpandedMode:(BOOL)expandedMode {
	[self _transitionToExpandedMode:expandedMode force:NO];
}

- (void)_transitionToExpandedMode:(BOOL)expanded force:(BOOL)force {
	if (force || _expanded != expanded) {
		_expanded = expanded;

		if (!isIOS11Mode && _hybridBackgroundView) {
			if (expanded) {
				//_hybridBackgroundView.hidden = NO;
				_hybridTintingView.alpha = 1.0;
			//	_hybridBackgroundView.appliesOutputSettingsAnimationDuration = 2.0;
				[_hybridBackgroundView transitionToStyle:1000];
				// _moduleVibrantBackground.layer.filters = nil;
				// _moduleVibrantBackground.layer.compositingFilter = _expandedBackgroundFilter;
			} else {
				_hybridTintingView.alpha = 0.0;
				//_moduleVibrantBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
				// CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantLight"];
				// [filter setValue:(id)[[UIColor colorWithWhite:0.11 alpha:0.3] CGColor] forKey:@"inputColor0"];
				// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.05] CGColor] forKey:@"inputColor1"];
				// [filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
				// _moduleVibrantBackground.layer.compositingFilter = nil;
				// _moduleVibrantBackground.layer.filters = [NSArray arrayWithObjects:_compactBackgroundFilter, nil];
				//_hybridBackgroundView.appliesOutputSettingsAnimationDuration = 0.3;
				[_hybridBackgroundView transitionToStyle:-2];
				//_hybridBackgroundView.alpha = 0.0;
			}
		}
	}
}
@end