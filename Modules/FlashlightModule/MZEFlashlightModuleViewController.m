#import "MZEFlashlightModuleViewController.h"
#import <MaizeUI/MZELayoutOptions.h>

NSString *const FlashlightLevelKey = @"mze_flashlightlevel";

static AVFlashlight *flashlight;

@implementation MZEFlashlightModuleViewController


+ (AVFlashlight *)currentFlashlight; {
	return flashlight;
}

+ (instancetype)sharedFlashlightModule {
	static MZEFlashlightModuleViewController *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSClassFromString(@"MZEFlashlightModuleViewController") alloc] init];
    });
    return _sharedInstance;
}



- (id)init {
	self = [super init];
	if (self) {
		_expanded = NO;
		_userDefaults = [NSUserDefaults standardUserDefaults];
		flashlight = [NSClassFromString(@"AVFlashlight") sharedFlashlight];
		[flashlight addObserver:self forKeyPath:@"available" options:0 context:NULL];
		[flashlight addObserver:self forKeyPath:@"flashlightLevel" options:0 context:NULL];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFlashlightMade:) name:@"MZENewFlashlightMade" object:nil];
	}
	return self;
}

- (void)updateToggleState {
	if (!flashlight) {
		[self newFlashlightMade:nil];
	}

	[self setEnabled:[flashlight isAvailable]];
	BOOL isSelected = [flashlight flashlightLevel] > 0 ? YES : NO;
	[self setSelected:isSelected];
	if ([flashlight flashlightLevel] > 0) {
		[_userDefaults setFloat:[flashlight flashlightLevel] forKey:FlashlightLevelKey];
		[_userDefaults synchronize];
		_sliderView.value = ([flashlight flashlightLevel]*(float)((float)_sliderView.numberOfSteps - 1.0f) + 1)/(float)_sliderView.numberOfSteps; 
	}
	if (_module) {
		[_module setSelected:isSelected];
	}
}

- (void)newFlashlightMade:(NSNotification *)notification {
	if (flashlight) {
		@try{
			[flashlight removeObserver:self forKeyPath:@"available" context:NULL];
			[flashlight removeObserver:self forKeyPath:@"flashlightLevel" context:NULL];
		}@catch(id anException){
		   //do nothing, obviously it wasn't attached because an exception was thrown
		}
	}

	flashlight = [NSClassFromString(@"AVFlashlight") sharedFlashlight];
	[flashlight addObserver:self forKeyPath:@"available" options:0 context:NULL];
	[flashlight addObserver:self forKeyPath:@"flashlightLevel" options:0 context:NULL];
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

	if (!flashlight) {
		[self newFlashlightMade:nil];
	}

	float flashLevel = (float)(_sliderView.step - 1)/(float)(_sliderView.numberOfSteps - 1);
	[_userDefaults setFloat:flashLevel forKey:FlashlightLevelKey];
	[_userDefaults synchronize];

	if (sliderView.step > 1) {
		[flashlight setFlashlightLevel:flashLevel withError:nil];
		if (_module) {
			[_module setSelected:YES];
		}
	} else {
		[flashlight turnPowerOff];
		if (_module) {
			[_module setSelected:NO];
		}
	}
}

- (void)buttonTapped:(UIControl *)button forEvent:(id)event {

	if (!flashlight) {
		[self newFlashlightMade:nil];
	}

	if ([flashlight flashlightLevel] > 0) {
		[flashlight turnPowerOff];
		if (_module) {
			[_module setSelected:NO];
		}
	} else {
		float flashLevel = (float)[_userDefaults floatForKey:FlashlightLevelKey];
		if (flashLevel > 0) {
			[flashlight setFlashlightLevel:flashLevel withError:nil];
		} else {
			[flashlight setFlashlightLevel:(float)1.0f withError:nil];
			[_userDefaults setFloat:1.0f forKey:FlashlightLevelKey];
			[_userDefaults synchronize];
		}

		if (_module) {
			[_module setSelected:YES];
		}
	}
}

- (BOOL)shouldBeginTransitionToExpandedContentModule {
	return [[NSClassFromString(@"AVFlashlight") sharedFlashlight] isAvailable];
}

- (CGFloat)preferredExpandedContentHeight {
	return [MZELayoutOptions defaultExpandedSliderHeight];
}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedSliderWidth];
}

- (void)willTransitionToExpandedContentMode:(BOOL)willTransition {
	_expanded = willTransition;
	if (!flashlight) {
		[self newFlashlightMade:nil];
	}

	if (_expanded) {
		if ([flashlight flashlightLevel] <= 0) {
			_sliderView.step = 1;
			_sliderView.value = (float)1.0f/(float)_sliderView.numberOfSteps;
		} else {
			_sliderView.value = ([flashlight flashlightLevel]*(float)((float)_sliderView.numberOfSteps - 1.0f) + 1)/(float)_sliderView.numberOfSteps;
		}
	}
	//[UIView performWithoutAnimation:^{
		//_sliderView.layerCornerRadius = willTransition ? [MZELayoutOptions expandedModuleCornerRadius] : [MZELayoutOptions regularCornerRadius];
	//}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object) {
		if ([object isKindOfClass:NSClassFromString(@"AVFlashlight")]) {
			[self updateToggleState];
		}
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	//_expanded = size.width > self.view.bounds.size.width;
	//_sliderView.clipsToBounds = NO;
   // [_sliderView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	// if (_expanded) {
	// 	[UIView performWithoutAnimation:^{
	// 		self.buttonView.alpha = 0;
	// 	}];
	// }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    	if (!_expanded) {
    		[UIView animateWithDuration:0.1f delay:_expanded ? 0.1 : 0.0 options:0 animations:^{
    		//	self.buttonView.alpha = _expanded ? 0.0 : 1.0;
    		} completion:nil];
    	}
    	self.buttonView.alpha = _expanded ? 0.0 : 1.0;
    	[_sliderView setAlpha:_expanded ? 1.0 : 0.0];
        [_sliderView setNeedsLayout];
		[_sliderView layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)dealloc {
	_sliderView = nil;
	_userDefaults = nil;
	if (flashlight) {
		@try{
			[flashlight removeObserver:self forKeyPath:@"available" context:NULL];
			[flashlight removeObserver:self forKeyPath:@"flashlightLevel" context:NULL];
		}@catch(id anException){
		   //do nothing, obviously it wasn't attached because an exception was thrown
		}
	}
}
@end