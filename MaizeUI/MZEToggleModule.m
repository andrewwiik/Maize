#import "MZEToggleModule.h"

@implementation MZEToggleModule
	@dynamic selectedColor;
	@dynamic selectedIconGlyph;
	@dynamic iconGlyph;
	@dynamic selected;

- (void)refreshState {
	[_viewController refreshState];
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEToggleViewController alloc] init];
		[_viewController setModule:self];
	}
	return _viewController;
}


@end