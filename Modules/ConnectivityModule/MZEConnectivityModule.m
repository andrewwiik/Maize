#import "MZEConnectivityModule.h"

@implementation MZEConnectivityModule

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEConnectivityModuleViewController alloc] initWithNibName:nil bundle:nil];
		//[_viewController setModule:self];
	}
	return _viewController;
}
@end