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

@property(retain, nonatomic, readwrite) MZECAPackageView *glyphPackageView; // @synthesize glyphPackageView=_glyphPackageView;
@property(retain, nonatomic, readwrite) UIImageView *highlightedGlyphView; // @synthesize highlightedGlyphView=_highlightedGlyphView;
@property(retain, nonatomic, readwrite) UIImageView *glyphImageView; // @synthesize glyphImageView=_glyphImageView;
@property(retain, nonatomic, readwrite) UIView *highlightStateBackgroundView; // @synthesize highlightStateBackgroundView=_highlightStateBackgroundView;
@property(retain, nonatomic, readwrite) MZEMaterialView *normalStateBackgroundView; // @synthesize normalStateBackgroundView=_normalStateBackgroundView;
@property(retain, nonatomic, readwrite) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(copy, nonatomic, readwrite) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic, readwrite) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;

- (id)initWithGlyphPackage:(CAPackage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithGlyphImage:(UIImage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithHighlightColor:(UIColor *)arg1;
- (void)_updateForStateChange;
- (void)_primaryActionPerformed:(id)arg1;
- (void)_dragExit:(id)arg1;
- (void)_dragEnter:(id)arg1;
- (void)_touchUpOutside:(id)arg1;
- (void)_touchDown:(id)arg1;
- (void)_setCornerRadius:(CGFloat)arg1;
- (CGFloat)_cornerRadius;
- (void)observeValueForKeyPath:(NSString *)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer;
@end