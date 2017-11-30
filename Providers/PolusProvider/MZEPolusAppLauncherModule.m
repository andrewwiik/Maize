#import "MZEPolusAppLauncherModule.h"

#import <Polus/PLPrefsHelper.h>
#import <Polus/PLAppsController.h>
#import <UIKit/UIImage+Private.h>

#import <MaizeShortcutKit/MZEShortcutItem.h>
#import <MaizeShortcutKit/MZEShortcutProvider.h>

#import "MZEPolusAppLauncherViewController.h"

extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);

@implementation MZEPolusAppLauncherModule
- (id)initWithIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_identifier = identifier;
	}
	return self;
}

- (NSString *)applicationIdentifier {
	return _identifier;
}

- (UIImage *)iconGlyph {
	if (!_cachedIconGlyph) {
		_cachedIconGlyph = [[[NSClassFromString(@"PLAppsController") sharedInstance] glyphOfSize:PLGlyphSizeNormal forAppIdentifier:_identifier withViewMode:PLViewModeBottomShelf] _flatImageWithColor:[UIColor whiteColor]];
	}
	return _cachedIconGlyph;
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEPolusAppLauncherViewController alloc] init];
		[_viewController setModule:self];
		NSArray<MZEShortcutItem *> *shortcutItems = [[MZEShortcutProvider sharedInstance] shortcutsForBundleIdentifier:[self applicationIdentifier]];

		for (MZEShortcutItem *shortcutItem in shortcutItems) {
			[_viewController addActionWithTitle:shortcutItem.title glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
		}

		_viewController.title = SBSCopyLocalizedApplicationNameForDisplayIdentifier([self applicationIdentifier]);

	}
	return _viewController;
}
@end