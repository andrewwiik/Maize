#import "MZEVibrantStyling.h"

@implementation MZEVibrantStyling
- (UIColor *)_burnColor {
	return (UIColor *)[self valueForKey:@"_burnColor"];
}
- (UIColor *)_darkenColor {
	return (UIColor *)[self valueForKey:@"_darkenColor"];
}
- (BOOL)_inputReversed {
	return NO;
}
- (_UIVisualEffectLayerConfig *)_layerConfig {
	_UIVisualEffectTintLayerConfig *layerConfig;
	layerConfig = [_UIVisualEffectTintLayerConfig layerWithTintColor:[self color]
														  filterType:[self blendMode]];
	return layerConfig;
}
- (CGFloat)alpha {
	return self.alpha;
}
- (NSString *)blendMode {
	return (NSString *)[self valueForKey:@"_blendMode"];
}
- (UIColor *)color {
	return (UIColor *)[self valueForKey:@"_color"];
}
- (CAFilter *)composedFilter {
	return (CAFilter *)[self valueForKey:@"_composedFilter"];
}
- (NSInteger)style {
	return 0;
}
@end