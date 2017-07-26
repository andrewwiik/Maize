#import "MZEToggleModule.h"

@implementation MZEToggleModule
	@dynamic selectedColor;
	@dynamic selectedIconGlyph;
	@dynamic iconGlyph;
	@dynamic selected;

- (void)refreshState {
	[_viewController refreshState];
}

- (UIColor *)selectedColor {
	return nil;
}

- (UIImage *)iconGlyph {
	return nil;
}

- (UIImage *)selectedIconGlyph {
	return nil;
}

- (CAPackage *)glyphPackage {
	return nil;
}

- (NSString *)glyphState {
	return nil;
}

- (BOOL)isSelected {
	return NO;
}

- (void)setSelected:(BOOL)selected {
	//[_viewController setSelected:selected];
	return;
}

- (UIViewController<MZEContentModuleContentViewController> *)contentViewController {
	if (!_viewController) {
		_viewController = [[MZEToggleViewController alloc] init];
		[_viewController setModule:self];
	}
	return _viewController;
}


@end