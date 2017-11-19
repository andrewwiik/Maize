#import "MZEPolusActionLauncherModule.h"
#import <Activator/Activator+Private.h>
#import <Polus/PLPrefsHelper.h>
#import <Polus/PLAppsController.h>
#import <UIKit/UIImage+Private.h>
#import "MZEPolusProvider.h"

@implementation MZEPolusActionLauncherModule
	@dynamic iconGlyph;
	@dynamic enabled;

- (id)initWithIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_identifier = identifier;
	}
	return self;
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEPolusActionLauncherViewController alloc] init];
		[_viewController setModule:self];
		// NSArray<MZEShortcutItem *> *shortcutItems = [[MZEShortcutProvider sharedInstance] shortcutsForBundleIdentifier:[self applicationIdentifier]];

		// for (MZEShortcutItem *shortcutItem in shortcutItems) {
		// 	[_viewController addActionWithTitle:shortcutItem.title glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
		// }

		_viewController.title = [MZEPolusProvider displayNameForIdentifier:_identifier];

	}
	return _viewController;
}

- (UIImage *)iconGlyph {
	if (!_cachedIconGlyph) {
		_cachedIconGlyph = [[[NSClassFromString(@"PLAppsController") sharedInstance] glyphOfSize:PLGlyphSizeNormal forAppIdentifier:_identifier withViewMode:PLViewModeBottomShelf] _flatImageWithColor:[UIColor whiteColor]];
	}
	return _cachedIconGlyph;
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
	return _identifier;
}
@end