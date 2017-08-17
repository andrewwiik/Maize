@interface MZELayoutOptions : NSObject
+ (CGFloat)deviceWidth;
+ (CGFloat)deviceHeight;

+ (BOOL)isRTL;

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
+ (CGFloat)defaultExpandedSliderHeight;
+ (CGFloat)defaultExpandedSliderWidth;
+ (CGRect)orientationRelativeScreenBounds;
+ (CGFloat)defaultExpandedModuleWidth; 
+ (CGFloat)defaultMenuItemHeight;

+ (CGFloat)expandedContinuousCornerRadius;
+ (CGFloat)regularContinuousCornerRadius;
+ (CGRect)regularCornerCenter;
+ (CGRect)expandedCornerCenter;

#pragma mark FlipSwitch Support

+ (CGPoint)flipSwitchGlyphOrigin;
+ (CGFloat)flipSwitchGlyphSize;
@end