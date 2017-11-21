#import <UIKit/_UIBackdropViewSettings.h>

@interface _UIBackdropViewSettings (Extra)
@property (assign,nonatomic) CGFloat blurRadius;
@property (assign,nonatomic) CGFloat saturationDeltaFactor;
@property (assign,nonatomic) BOOL usesGrayscaleTintView;                                 //@synthesize usesGrayscaleTintView=_usesGrayscaleTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorTintView;                                     //@synthesize usesColorTintView=_usesColorTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorBurnTintView;                                 //@synthesize usesColorBurnTintView=_usesColorBurnTintView - In the implementation block
@property (assign,nonatomic) BOOL usesContentView;                                       //@synthesize usesContentView=_usesContentView - In the implementation block
@property (assign,nonatomic) BOOL usesDarkeningTintView;                                 //@synthesize usesDarkeningTintView=_usesDarkeningTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorOffset;
+ (instancetype)settingsForStyle:(NSInteger)arg1 ;
@property (assign,nonatomic) CGFloat scale;
@property (nonatomic,copy) NSString * blurQuality;
@end