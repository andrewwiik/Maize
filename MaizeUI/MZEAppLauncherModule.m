#import "MZEAppLauncherModule.h"
#import <MaizeShortcutKit/MZEShortcutItem.h>
#import <MaizeShortcutKit/MZEShortcutProvider.h>

@implementation MZEAppLauncherModule
	@dynamic iconGlyph;
	@dynamic enabled;

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEAppLauncherViewController alloc] init];
		[_viewController setModule:self];
		NSArray<MZEShortcutItem *> *shortcutItems = [[MZEShortcutProvider sharedInstance] shortcutsForBundleIdentifier:[self applicationIdentifier]];

		for (MZEShortcutItem *shortcutItem in shortcutItems) {
			[_viewController addActionWithTitle:shortcutItem.title glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
		}

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