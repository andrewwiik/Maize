#import "MZEFlipSwitchToggleModule.h"

@interface MZEAnimatedFlipSwitchToggleModule : MZEFlipSwitchToggleModule
- (id)initWithSwitchIdentifier:(NSString *)switchIdentifier;
- (UIColor *)selectedColor;
- (UIImage *)iconGlyph;
- (UIImage *)selectedIconGlyph;
@end