#import <QuartzCore/CAPackage+Private.h>
#import "MZECAPackageView.h"
#import "MZEMaterialView.h"


@interface MZERoundButton : UIControl {
    CAPackage *_glyphPackage;
    UIImage *_glyphImage;
    NSString *_glyphState;
    UIColor *_highlightColor;
    MZEMaterialView *_normalStateBackgroundView;
    UIView *_highlightStateBackgroundView;
    UIImageView *_glyphImageView;
    UIImageView *_highlightedGlyphView;
    MZECAPackageView *_glyphPackageView;
}

@property(retain, nonatomic) MZECAPackageView *glyphPackageView; // @synthesize glyphPackageView=_glyphPackageView;
@property(retain, nonatomic) UIImageView *highlightedGlyphView; // @synthesize highlightedGlyphView=_highlightedGlyphView;
@property(retain, nonatomic) UIImageView *glyphImageView; // @synthesize glyphImageView=_glyphImageView;
@property(retain, nonatomic) UIView *highlightStateBackgroundView; // @synthesize highlightStateBackgroundView=_highlightStateBackgroundView;
@property(retain, nonatomic) MZEMaterialView *normalStateBackgroundView; // @synthesize normalStateBackgroundView=_normalStateBackgroundView;
@property(retain, nonatomic) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(copy, nonatomic) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(retain, nonatomic) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;

- (id)initWithGlyphPackage:(CAPackage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithGlyphImage:(UIImage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithHighlightColor:(UIColor *)arg1;
@end