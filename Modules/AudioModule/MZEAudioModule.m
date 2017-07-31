#import "MZEAudioModule.h"

@implementation MZEAudioModule

- (UIViewController *)backgroundViewController {
	_backgroundViewController = [[MZESliderModuleBackgroundViewController alloc] initWithNibName:nil bundle:nil];
    [_backgroundViewController setGlyphPackage:[self _audioGlyphPackage]];
    [_backgroundViewController setGlyphState:[self _audioGlyphStateForVolumeLevel:[_moduleViewController currentVolume]]];
    return _backgroundViewController;
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	 _moduleViewController = [[MZEAudioModuleViewController alloc] initWithNibName:nil bundle:nil];
    [_moduleViewController setGlyphPackage:[self _audioGlyphPackage]];
    [_moduleViewController setOtherGlyphPackage:[self _audioGlyphPackage]];
    [_moduleViewController setGlyphState:[self _audioGlyphStateForVolumeLevel:[_moduleViewController currentVolume]]];
    [_moduleViewController setDelegate:self];
    return _moduleViewController;
}

- (void)audioModuleViewController:(id)moduleViewController volumeDidChange:(float)volume {
	[_moduleViewController setGlyphState:[self _audioGlyphStateForVolumeLevel:volume]];
	[_backgroundViewController setGlyphState:[self _audioGlyphStateForVolumeLevel:volume]];
}

- (CAPackage *)_audioGlyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Volume" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)_audioGlyphStateForVolumeLevel:(CGFloat)volumeLevel {
	/*
	0 - 0.0625 : mute
	0.626 - 0.329 : off
	0.33 - 0.499 : min
	0.5 - 0.749 : half
	0.749 - 2 : full
	*/

	if (volumeLevel >= 1.0) {
		return @"max";
	} else if (volumeLevel > 0.75) {
		return @"full";
	} else if (volumeLevel >= 0.5) {
		return @"half";
	} else if (volumeLevel > 0.0625) {
		return @"min";
	} else {
		return @"mute";
	}
}
@end