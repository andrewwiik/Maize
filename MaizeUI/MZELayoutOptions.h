@interface MZELayoutOptions : NSObject
+ (CGFloat)itemSpacingSize;
+ (CGFloat)edgeSize;
+ (CGFloat)edgeInsetSize;
+ (void)setupInterpolators;
+ (CGFloat)roundButtonSize;
+ (CGFloat)roundButtonTitlePaddingSize;
+ (CGFloat)roundButtonSubtitlePaddingSize;
+ (CGFloat)roundButtonExpandedSideInsetSize;
+ (CGSize)roundButtonContainerExpandedSize;
+ (CGFloat)regularCornerRadius;
+ (CGFloat)expandedModuleCornerRadius;
+ (CGFloat)defaultExpandedContentModuleWidth;

#pragma mark FlipSwitch Support

+ (CGPoint)flipSwitchGlyphOrigin;
+ (CGFloat)flipSwitchGlyphSize;
@end