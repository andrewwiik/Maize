#import <UIKit/_UIBackdropView+Private.h>

@interface MZEContentModuleBackgroundView : UIView {
	BOOL _expanded;
	_UIBackdropView *_hybridBackgroundView;
	UIView *_hybridTintingView;
}
- (void)setUserInteractionEnabled:(BOOL)arg1;
- (id)initWithFrame:(CGRect)arg1;
- (void)transitionToExpandedMode:(BOOL)arg1;
- (void)_transitionToExpandedMode:(BOOL)arg1 force:(BOOL)arg2;
@end