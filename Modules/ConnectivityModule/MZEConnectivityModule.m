#import "MZEConnectivityModule.h"

@implementation MZEConnectivityModule

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEConnectivityModuleViewController alloc] init];
		//[_viewController setModule:self];
	}
	return _viewController;
}
@end