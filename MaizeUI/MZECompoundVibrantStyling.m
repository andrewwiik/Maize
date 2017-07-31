#import <QuartzCore/CAFilter+Private.h>
#import "MZECompoundVibrantStyling.h"

@implementation MZECompoundVibrantStyling
- (UIColor *)_burnColor {
	return nil;
}
- (UIColor *)_darkenColor {
	return nil;
}
- (BOOL)_inputReversed {
	return NO;
}

- (_UIVisualEffectLayerConfig *)_layerConfig {

	NSDictionary *filterAttributes = @{@"inputReversed":[NSNumber numberWithBool:[self _inputReversed]]};
	_UIVisualEffectVibrantLayerConfig *layerConfig;
	layerConfig = [_UIVisualEffectVibrantLayerConfig layerWithVibrantColor:[self _burnColor]
																 tintColor:[self _darkenColor]
															    filterType:[self blendMode]
														  filterAttributes:filterAttributes];
	return layerConfig;
}

- (NSString *)blendMode {
	return @"";
}

- (CAFilter *)composedFilter {
	if (![self valueForKey:@"_composedFilter"] && [[self blendMode] length] != 0) {
		CAFilter *composedFilter = [CAFilter filterWithType:[self blendMode]];
		[composedFilter setValue:(id)[[self _burnColor] CGColor] forKey:@"inputColor0"];
		[composedFilter setValue:(id)[[self _darkenColor] CGColor] forKey:@"inputColor1"];
		[composedFilter setValue:[NSNumber numberWithBool:[self _inputReversed]] forKey:@"inputReversed"];
		[self setValue:composedFilter forKey:@"_composedFilter"];
	}
	return (CAFilter *)[self valueForKey:@"_composedFilter"];
}
@end