
#import <Sharing/SFAirDropDiscoveryController.h>
#import <Sharing/SFAirDropDiscoveryControllerDelegate-Protocol.h>
#import <MaizeUI/MZEMenuModuleViewController.h>
#import "MZEConnectivityButtonViewController.h"
#import <MaizeUI/MZEMaterialView.h>
#import <MaizeUI/MZEExpandedModuleTransition-Protocol.h>
#import <MaizeUI/MZEExpandedModulePresentationTransition.h>
#import <MaizeUI/MZEExpandedModulePresentationController.h>
#import <MaizeUI/MZEExpandedModuleDismissTransition.h>
#import "MZEConnectivityAirDropPopupContentViewController.h"

@interface MZEConnectivityAirDropPopupViewController : UIViewController <MZEExpandedModuleTransition, UIViewControllerTransitioningDelegate> {
	SFAirDropDiscoveryController *_discoveryController;
	UIView *_containerView;
	UIView *_tapBackgroundView;
	MZEConnectivityAirDropPopupContentViewController *_contentViewController;
	NSBundle *_bundle;
	MZEConnectivityButtonViewController *_buttonController;
}
@property (nonatomic, retain, readwrite) SFAirDropDiscoveryController *discoveryController;
@property (nonatomic, retain, readwrite) MZEConnectivityAirDropPopupContentViewController *contentViewController;
@property (nonatomic, retain, readwrite) MZEConnectivityButtonViewController *buttonController;
- (id)initWithDiscoveryController:(SFAirDropDiscoveryController *)discoveryController;
@end

// - (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
// 	if (!_viewController) {
// 		_viewController = [[MZEAppLauncherViewController alloc] init];
// 		[_viewController setModule:self];
// 		NSArray<MZEShortcutItem *> *shortcutItems = [[MZEShortcutProvider sharedInstance] shortcutsForBundleIdentifier:[self applicationIdentifier]];

// 		for (MZEShortcutItem *shortcutItem in shortcutItems) {
// 			[_viewController addActionWithTitle:shortcutItem.title glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
// 		}

// 		_viewController.title = SBSCopyLocalizedApplicationNameForDisplayIdentifier([self applicationIdentifier]);

// 	}
// 	return _viewController;
// }

