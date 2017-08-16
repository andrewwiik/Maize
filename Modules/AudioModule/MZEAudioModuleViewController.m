#import "MZEAudioModuleViewController.h"
#import <MaizeUI/MZELayoutOptions.h>
#import <UIKit/UIApplication+VolumeHUD.h>
#import <UIKit/UIView+Private.h>

@implementation MZEAudioModuleViewController
	@synthesize delegate=_delegate;

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
            _sliderView = [[MZEModuleSliderView alloc] initWithFrame:CGRectZero];
            [_sliderView setThrottleUpdates:YES];
          //  _sliderView._continuousCornerRadius = [MZELayoutOptions regularCornerRadius];
          //  _sliderView.clipsToBounds = YES;
            [_sliderView addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
            _volumeController = [[MPVolumeController alloc] init];
            [_volumeController setDelegate:self];
	}
	return self;
}

- (void)loadView {
	[_sliderView setValue:[self currentVolume]];
	[self setView:_sliderView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[_delegate audioModuleViewController:self volumeDidChange:[self currentVolume]];
}

- (float)currentVolume {
	return [_volumeController volumeValue];
}

- (void)setGlyphState:(NSString *)glyphState {
	[_sliderView setGlyphState:glyphState];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	[_sliderView setGlyphPackage:glyphPackage];
}

// - (void)setOtherGlyphPackage:(CAPackage *)otherGlyphPackage {
// 	[_sliderView setOtherGlyphPackage:otherGlyphPackage];
// }

- (CGFloat)preferredExpandedContentHeight {
	return [MZELayoutOptions defaultExpandedSliderHeight];
}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedSliderWidth];
}

- (void)willTransitionToExpandedContentMode:(BOOL)willTransition {
	_expanded = willTransition;

	// if (_expanded) {
	// 	[UIView animateWithDuration:0 animations:^{
	// 		[_sliderView setGlyphVisible:NO];
	// 	}];
	// } else {
	// 	[UIView animateWithDuration:0.0 delay:0.285 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
	// 		[_sliderView setGlyphVisible:YES];
	// 	} completion:nil];
	// }
	// if (willTransition) {
	// 	[_sliderView setGlyphVisible:NO];
	// }
	//_sliderView.layerCornerRadius = willTransition ? [MZELayoutOptions expandedModuleCornerRadius] : [MZELayoutOptions regularCornerRadius];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	//_sliderView.clipsToBounds = NO;
   // [_sliderView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	// if (_expanded) {
	// 	[UIView animateWithDuration:0.0f delay:0.0f options:0 animations:^{
	// 		[_sliderView setGlyphVisible:YES];
	// 	} completion:nil];
	// } else {
	// 	[UIView animateWithDuration:0.0f delay:0.285f options:0 animations:^{
	// 		[_sliderView setGlyphVisible:NO];
	// 	} completion:nil];
	// }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

   //  	[UIView performWithoutAnimation:^{
   //  		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.23 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			//     [UIView performWithoutAnimation:^{
			// 		[_sliderView setGlyphVisible:YES];
			// 	}];
			// });
   //  	}];
		if (_expanded) {
			[UIView animateWithDuration:0.0 animations:^{
				[UIView performWithoutAnimation:^{
					[_sliderView setGlyphVisible:NO];
				}];
			}];
		} else {

			[UIView performWithoutAnimation:^{
	    		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				    [UIView performWithoutAnimation:^{
						[_sliderView setGlyphVisible:YES];
					}];
				});
	    	}];
			// [UIView animateWithDuration:0.0 delay:1.0 options:0 animations:^{
			// 	[UIView performWithoutAnimation:^{
			// 		[_sliderView setGlyphVisible:YES];
			// 	}];
			// } completion:nil];
		}
		[_sliderView setSeparatorsHidden:YES];
		[_sliderView setNeedsLayout];
		[_sliderView layoutIfNeeded];
		//[_sliderView setSeparatorsHidden:YES];
		// } else {
		// 	[UIView animateWithDuration:0.0f delay:0.285f options:0 animations:^{
		// 		[_sliderView setGlyphVisible:YES];
		// 	} completion:nil];
		// }
		// [_sliderView _layoutValueViews];
		// [_sliderView setGlyphVisible:_expanded ? NO : YES];
		//_sliderView.layer.cornerRadius = _expanded ? [MZELayoutOptions expandedModuleCornerRadius] : [MZELayoutOptions regularCornerRadius];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    	[_sliderView setSeparatorsHidden:NO];
    	// if (!_expanded) {
    	// 	[_sliderView setGlyphVisible:YES];
    	// }
    	// if (!_expanded) {
    	// 	[_sliderView setGlyphVisible:YES];
    	// } 
    	//[_sliderView stopDisplayLink];
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)willResignActive {
	[[UIApplication sharedApplication] setSystemVolumeHUDEnabled:YES];
}

- (void)willBecomeActive {
	[[UIApplication sharedApplication] setSystemVolumeHUDEnabled:NO];
}

- (BOOL)isContentClippingRequired {
	return NO;
}

- (BOOL)isGroupRenderingRequired {
	return [_sliderView isGroupRenderingRequired];
}

- (void)_sliderValueDidChange:(MZEModuleSliderView *)slider {
	[_volumeController setVolumeValue:[slider value]];
}

- (void)volumeController:(MPVolumeController *)volumeController volumeValueDidChange:(float)volume {
	if (![_sliderView isTracking]) {
		[UIView animateWithDuration:0.5 animations:^{
			[_sliderView setValue:volume];
		}];
	}

	[_delegate audioModuleViewController:self volumeDidChange:volume];
}

- (CALayer *)punchOutRootLayer {
	return [_sliderView punchOutRootLayer];
}

@end