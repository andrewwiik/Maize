#import "MZEAirPlayMirroringModule.h"
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>

@implementation MZEAirPlayMirroringModule

// - (id)init {
// 	self = [super init];
// 	if (self) {
// 		_moduleBundle = [NSBundle bundleForClass:[self class]];
// 	}
// 	return self;
// }

// - (UIImage *)iconGlyph {
// 	if (!_cachedIconGlyph) {
// 		_cachedIconGlyph = [[UIImage imageNamed:@"AppIcon" inBundle:_moduleBundle] _flatImageWithColor:[UIColor whiteColor]];
// 	}
// 	return _cachedIconGlyph;
// }

// - (NSString *)applicationIdentifier {
// 	return @"com.apple.camera";
// }

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"MPAVScreenMirroring" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEAirPlayMirroringModuleViewController alloc] init];
		[_viewController setModule:self];
		_viewController.title = [[NSBundle bundleForClass:[self class]] localizedStringForKey:@"Screen Mirroring Expanded" value:@"" table:nil];
		//[_viewController setModule:self];
	}
	return _viewController;
}
@end