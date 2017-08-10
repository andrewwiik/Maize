#import "MZEMediaModule.h"

@implementation MZEMediaModule

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEMediaModuleViewController alloc] initWithNibName:nil bundle:nil];
		//[_viewController setModule:self];
	}
	return _viewController;
}
@end
