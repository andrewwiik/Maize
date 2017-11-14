#import "MZEConnectivityAirDropPopupContentViewController.h"
#import <UIKit/UIImage+Private.h>
#import <MaizeUI/MZEMenuModuleItemView.h>
#import "MZEConnectivityAirDropPopupViewController.h"

@implementation MZEConnectivityAirDropPopupContentViewController

- (id)initWithRootController:(MZEConnectivityAirDropPopupViewController *)rootController {
	self = [self init];
	if (self) {
		_rootController = rootController;
	}
	return self;
}

- (BOOL)providesOwnPlatter {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setGlyphImage:[UIImage imageNamed:@"AirDropGlyph" inBundle:[NSBundle bundleForClass:[self class]]]];
	[self _fadeViewsForExpandedState:YES];
	// [_viewController addActionWithTitle: glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
}



- (void)_handleActionTapped:(MZEMenuModuleItemView *)menuItemView {
	if (menuItemView.handler()) {
		[self.rootController dismissViewControllerAnimated:YES completion:^{
			[self.rootController.buttonController didDismissSecondaryViewController:self.rootController];
		}];
	}
}
@end
