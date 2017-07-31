#import "MZEAudioModuleViewController.h"
#import <MaizeUI/MZELayoutOptions.h>
#import <UIKit/UIApplication+VolumeHUD.h>

@implementation MZEAudioModuleViewController
	@synthesize delegate=_delegate;

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
            _sliderView = [[MZEModuleSliderView alloc] initWithFrame:CGRectZero];
            [_sliderView setThrottleUpdates:YES];
            _sliderView.layer.cornerRadius = [MZELayoutOptions regularCornerRadius];
            _sliderView.clipsToBounds = YES;
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

- (void)setOtherGlyphPackage:(CAPackage *)otherGlyphPackage {
	[_sliderView setOtherGlyphPackage:otherGlyphPackage];
}

- (CGFloat)preferredExpandedContentHeight {
	return [MZELayoutOptions defaultExpandedSliderHeight];
}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedSliderWidth];
}

- (void)willTransitionToExpandedContentMode:(BOOL)willTransition {
	[_sliderView setGlyphVisible:willTransition ? NO : YES];
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