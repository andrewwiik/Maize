#import "MZEFlashlightModule.h"
#import "MZEFlashlightModuleViewController.h"
#import <UIKit/UIColor+Private.h>
#import <AVFoundation/AVFlashlight.h>

@implementation MZEFlashlightModule


+ (BOOL)isSupported {
	return [NSClassFromString(@"AVFlashlight") hasFlashlight];
}

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.flashlight"];
	if (self) {

	}
	return self;
}

- (UIColor *)selectedColor {
	return [UIColor systemBlueColor];
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEFlashlightModuleViewController alloc] init];
		[_viewController setModule:self];
	}
	return _viewController;
}

@end