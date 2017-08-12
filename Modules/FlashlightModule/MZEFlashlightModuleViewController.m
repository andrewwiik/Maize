#import "MZEFlashlightModuleViewController.h"
#import <MaizeUI/MZELayoutOptions.h>

@implementation MZEFlashlightModuleViewController
- (id)init {
	self = [super init];
	if (self) {
		_expanded = NO;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	if (!_sliderView) {
		_sliderView = [[MZEModuleSliderView alloc] initWithFrame:self.view.bounds];
           // _sliderView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
       // _sliderView.clipsToBounds = YES;
		_sliderView.numberOfSteps = 5;
		_sliderView.firstStepIsDisabled = YES;
		[_sliderView setGlyphVisible:NO];
        [_sliderView setThrottleUpdates:NO];
        [_sliderView addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
        _sliderView.alpha = 0;
        [self.view addSubview:_sliderView];
        [_sliderView  setAutoresizingMask:18];
	}
}

- (void)_sliderValueDidChange:(MZEModuleSliderView *)sliderView {

}

- (BOOL)shouldBeginTransitionToExpandedContentModule {
	return YES;
}

- (CGFloat)preferredExpandedContentHeight {
	return [MZELayoutOptions defaultExpandedSliderHeight];
}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedSliderWidth];
}

- (void)willTransitionToExpandedContentMode:(BOOL)willTransition {
	_expanded = willTransition;
	//[UIView performWithoutAnimation:^{
		//_sliderView.layerCornerRadius = willTransition ? [MZELayoutOptions expandedModuleCornerRadius] : [MZELayoutOptions regularCornerRadius];
	//}];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	//_sliderView.clipsToBounds = NO;
   // [_sliderView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    	[_sliderView setAlpha:_expanded ? 1.0 : 0.0];
    	self.buttonView.alpha = _expanded ? 0.0 : 1.0;
        [_sliderView setNeedsLayout];
		[_sliderView layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end