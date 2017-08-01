#import "MZEDisplayModuleViewController.h"
#import <MaizeUI/MZELayoutOptions.h>
#import <UIKit/UIApplication+VolumeHUD.h>
#import <BackBoardServices/BKSDisplayBrightness.h>
#import <SpringBoard/SBBrightnessController+Private.h>

@implementation MZEDisplayModuleViewController
	@synthesize delegate=_delegate;

- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	self = [super initWithNibName:arg1 bundle:arg2];
	if (self) {
            _sliderView = [[MZEModuleSliderView alloc] initWithFrame:CGRectZero];
            _sliderView.layer.cornerRadius = [MZELayoutOptions regularCornerRadius];
            _sliderView.clipsToBounds = YES;
            [_sliderView setThrottleUpdates:NO];
            [_sliderView addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
	}
	return self;
}

- (void)loadView {
	[_sliderView setValue:[self currentBrightness]];
	[self setView:_sliderView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[_delegate displayModuleViewController:self brightnessDidChange:[self currentBrightness]];
}

- (float)currentBrightness {
	return [self _backlightLevel];
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

- (void)willBecomeActive {
	// [super viewWillAppear:willAppear];
	[self _updateWithCurrentBrightnessAnimated:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_noteScreenBrightnessDidChange:) name:@"UIScreenBrightnessDidChangeNotification" object:nil];
		
}

- (void)willResignActive {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIScreenBrightnessDidChangeNotification" object:nil];
}

- (void)_updateWithCurrentBrightnessAnimated:(BOOL)animated {

	if (![_sliderView isTracking]) {
		if (animated) {
			[UIView animateWithDuration:0.5 animations:^{
				[_sliderView setValue:[self _backlightLevel]];
			}];
		} else {
			[_sliderView setValue:[self _backlightLevel]];
		}
	}

	[_delegate displayModuleViewController:self brightnessDidChange:[self _backlightLevel]];
}

- (void)_noteScreenBrightnessDidChange:(id)changed {
	[self _updateWithCurrentBrightnessAnimated:YES];
}


- (BOOL)isContentClippingRequired {
	return NO;
}

- (BOOL)isGroupRenderingRequired {
	return [_sliderView isGroupRenderingRequired];
}

- (void)_sliderValueDidChange:(MZEModuleSliderView *)slider {
	[self _setBacklightLevel:[slider value]];
	//[_delegate displayModuleViewController:self brightnessDidChange:[slider value]];
}

- (CALayer *)punchOutRootLayer {
	return [_sliderView punchOutRootLayer];
}

- (float)_backlightLevel {
	return BKSDisplayBrightnessGetCurrent();
}

- (void)_setBacklightLevel:(float)backlightLevel {
	[[NSClassFromString(@"SBBrightnessController") sharedBrightnessController] _setBrightnessLevel:backlightLevel showHUD:NO];
	BKSDisplayBrightnessTransactionRef transaction = BKSDisplayBrightnessTransactionCreate(kCFAllocatorDefault);
	BKSDisplayBrightnessSet(BKSDisplayBrightnessGetCurrent(), 1);
	CFRelease(transaction);
}



@end