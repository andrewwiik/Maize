@interface UIImage (Private)
- (UIImage *)_applyBackdropViewSettings:(id)arg1;
- (UIImage *)_applyBackdropViewSettings:(id)arg1 includeTints:(BOOL)arg2 includeBlur:(BOOL)arg3;
- (UIImage *)sbf_scaleImage:(CGFloat)scale;
+ (UIImage *)imageNamed:(NSString *)arg1 inBundle:(id)arg2 ;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(int)arg2 ;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(NSInteger)arg2 scale:(CGFloat)arg3 ;
- (UIImage *)ccuiAlphaOnlyImageForMaskImage;
- (UIImage *)_flatImageWithColor:(UIColor *)color;

// @interface UIImage (Private)
// /*
//  @param format
//  0 - 29x29
//  1 - 40x40
//  2 - 62x62
//  3 - 42x42
//  4 - 37x48
//  5 - 37x48
//  6 - 82x82
//  7 - 62x62
//  8 - 20x20
//  9 - 37x48
//  10 - 37x48
//  11 - 122x122
//  12 - 58x58
//  */
// + (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
// + (UIImage*)getImageFromBundleNamed:(NSString*)name withExtension:(NSString*)extensio;
@end
@end