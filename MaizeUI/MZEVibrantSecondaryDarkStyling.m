#import "MZEVibrantSecondaryDarkStyling.h"

@implementation MZEVibrantSecondaryDarkStyling
- (UIColor *)_burnColor {
	return [UIColor colorWithWhite:0.4 alpha:1];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithWhite:0 alpha:0.3];
}
- (BOOL)_inputReversed {
	return YES;
}
- (CGFloat)alpha {
	return 1.0;
}
- (UIColor *)color {
	return [UIColor whiteColor];
}
- (NSInteger)style {
	return 13;
}
@end