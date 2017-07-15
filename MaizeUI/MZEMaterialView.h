#import "_MZEBackdropView.h"
#import <MPUFoundation/MPULayoutInterpolator.h>

typedef NS_ENUM(NSInteger, MZEMaterialStyle)
{
	MZEMaterialStyleNone,
    MZEMaterialStyleLight,
    MZEMaterialStyleDark,
    MZEMaterialStyleNormal
};

@interface MZEMaterialView : UIView {
	CGFloat _compactHeight;
	CGFloat _expandedHeight;
	CGFloat _compactCornerRadius;
	CGFloat _expandedCornerRadius;
	MPULayoutInterpolator *_cornerRadiusInterpolator;
}
@property (nonatomic, retain) _MZEBackdropView *backdropView;
@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat luminanceAlpha;
@property (nonatomic, retain) UIColor *colorMatrixColor;
@property (nonatomic, retain) UIColor *colorAddColor;
@property (nonatomic, retain) NSValue *forcedColorMatrix;
+ (instancetype)materialViewWithStyle:(MZEMaterialStyle)style;
- (void)updateCornerRadius;
- (void)setCompactCornerRadius:(CGFloat)compactCornerRadius expandedCornerRadius:(CGFloat)expandedCornerRadius compactSize:(CGSize)compactSize expandedSize:(CGSize)expandedSize;
// - (void)_setCornerRadius:(CGFloat)cornerRadius;
@end