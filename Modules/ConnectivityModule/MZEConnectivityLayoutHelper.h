@interface MZEConnectivityLayoutHelper : NSObject
+ (void)setupInterpolators;
+ (UIEdgeInsets)compactLayoutInsets;
+ (UIEdgeInsets)expandedLayoutInsetsForSize:(CGSize)size;
+ (CGFloat)buttonWidthForInsets:(UIEdgeInsets)insets containerSize:(CGSize)containerSize numberOfColumns:(NSUInteger)colCount;
+ (CGFloat)widthForExpandedContainerWithContainerSize:(CGSize)size defaultButtonSize:(CGSize)buttonSize;
@end