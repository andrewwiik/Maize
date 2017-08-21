#import "MZEAppLauncherModule.h"

@implementation MZEAppLauncherModule
	@dynamic iconGlyph;
	@dynamic enabled;

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEAppLauncherViewController alloc] init];
		[_viewController setModule:self];
	}
	return _viewController;
}

- (UIImage *)iconGlyph {
	return nil;
}

- (CAPackage *)glyphPackage {
	return nil;
}

- (NSString *)glyphState {
	return nil;
}

- (BOOL)isEnabled {
	return YES;
}

- (NSString *)applicationIdentifier {
	return _applicationIdentifier;
}
@end