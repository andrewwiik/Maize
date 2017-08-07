@interface _MZEBackdropView : UIView {
	CGFloat _brightness;
	CGFloat _saturation;
	CGFloat _luminanceAlpha;
	CGFloat _blurRadius;
	UIColor *_colorMatrixColor;
	UIColor *_colorAddColor;
	NSValue *_forcedColorMatrix;
}
@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat luminanceAlpha;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, retain) UIColor *colorMatrixColor;
@property (nonatomic, retain) UIColor *colorAddColor;
@property (nonatomic, retain) NSValue *forcedColorMatrix;
+ (Class)layerClass;
- (id)initWithStyleDictionary:(NSDictionary *)styleDictionary;
- (void)recomputeFilters;
- (void)setStyleDictionary:(NSDictionary *)styleDictionary;
@end