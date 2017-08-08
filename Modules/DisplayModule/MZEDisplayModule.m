#import "MZEDisplayModule.h"

@implementation MZEDisplayModule

- (UIViewController *)backgroundViewController {
	_backgroundViewController = [[MZESliderModuleBackgroundViewController alloc] initWithNibName:nil bundle:nil];
    [_backgroundViewController setGlyphPackage:[self _brightnessGlyphPackage]];
    [_backgroundViewController setGlyphState:[self _brightnessGlyphStateForBrightnessLevel:[_moduleViewController currentBrightness]]];
    return _backgroundViewController;
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	 _moduleViewController = [[MZEDisplayModuleViewController alloc] initWithNibName:nil bundle:nil];
    [_moduleViewController setGlyphPackage:[self _brightnessGlyphPackage]];
    [_moduleViewController setOtherGlyphPackage:[self _brightnessGlyphPackage]];
    [_moduleViewController setGlyphState:[self _brightnessGlyphStateForBrightnessLevel:[_moduleViewController currentBrightness]]];
    [_moduleViewController setDelegate:self];
    return _moduleViewController;
}

- (void)displayModuleViewController:(id)moduleViewController brightnessDidChange:(float)brightness {
	[_moduleViewController setGlyphState:[self _brightnessGlyphStateForBrightnessLevel:brightness]];
	[_backgroundViewController setGlyphState:[self _brightnessGlyphStateForBrightnessLevel:brightness]];
}

- (CAPackage *)_brightnessGlyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Brightness" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)_brightnessGlyphStateForBrightnessLevel:(float)brightnessLevel {
	/*
	0 - 0.0625 : mute
	0.626 - 0.329 : off
	0.33 - 0.499 : min
	0.5 - 0.749 : half
	0.749 - 2 : full
	*/

	brightnessLevel = [_moduleViewController currentBrightness];

	if (brightnessLevel >= 1.0) {
		return @"max";
	} else if (brightnessLevel > 0.75) {
		return @"full";
	} else if (brightnessLevel >= 0.5) {
		return @"half";
	} else if (brightnessLevel > 0.0625) {
		return @"mid";
	} else {
		return @"min";
	}
}
@end