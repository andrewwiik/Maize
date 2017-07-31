#import "MZEVibrantStyling.h"

@interface MZECompoundVibrantStyling : MZEVibrantStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (_UIVisualEffectLayerConfig *)_layerConfig;
- (NSString *)blendMode;
- (CAFilter *)composedFilter;
@end