#import "FSSwitchState.h"

@interface NSBundle (Flipswitch)
@property (nonatomic, readonly) NSBundle *flipswitchThemedBundle;
@property (nonatomic, readonly) NSDictionary *flipswitchThemedInfoDictionary;
@property (nonatomic, readonly) NSString *flipswitchImageCacheBasePath;

- (NSUInteger)imageSizeForFlipswitchImageName:(NSString *)glyphName closestToSize:(CGFloat)sourceSize inDirectory:(NSString *)directory;

- (NSString *)imagePathForFlipswitchImageName:(NSString *)imageName imageSize:(NSUInteger)imageSize preferredScale:(CGFloat)preferredScale controlState:(UIControlState)controlState inDirectory:(NSString *)directory;
- (NSString *)imagePathForFlipswitchImageName:(NSString *)imageName imageSize:(NSUInteger)imageSize preferredScale:(CGFloat)preferredScale controlState:(UIControlState)controlState inDirectory:(NSString *)directory loadedControlState:(UIControlState *)outImageControlState;

- (id)objectForResolvedInfoDictionaryKey:(NSString *)name withLayerSet:(NSString *)layerSet switchState:(FSSwitchState)state controlState:(UIControlState)controlState resolvedKeyName:(NSString **)outKeyName;
@end