#import "MZECAPackageView.h"
#import <QuartzCore/CAPackage+Private.h>
#import "UIView+MZE.h"

@interface MZEButtonModuleView : UIControl
{
    UIView *_highlightedBackgroundView;
    UIImageView *_glyphImageView;
    MZECAPackageView *_glyphPackageView;
    UIImage *_glyphImage;
    UIColor *_glyphColor;
    UIImage *_selectedGlyphImage;
    UIColor *_selectedGlyphColor;
    CAPackage *_glyphPackage;
    NSString *_glyphState;
}

@property(copy, nonatomic, readwrite) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;
@property(retain, nonatomic, readwrite) UIColor *selectedGlyphColor; // @synthesize selectedGlyphColor=_selectedGlyphColor;
@property(retain, nonatomic, readwrite) UIImage *selectedGlyphImage; // @synthesize selectedGlyphImage=_selectedGlyphImage;
@property(retain, nonatomic, readwrite) UIColor *glyphColor; // @synthesize glyphColor=_glyphColor;
@property(retain, nonatomic, readwrite) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
- (void)_setGlyphState:(NSString *)glyphState;
- (void)_setGlyphPackage:(CAPackage *)glyphPackage;
- (void)_setGlyphImage:(UIImage *)glyphImage;
- (void)_updateForStateChange;
- (void)_dragExit:(id)arg1;
- (void)_dragEnter:(id)arg1;
- (void)_touchUpOutside:(id)arg1;
- (void)_touchUpInside:(id)arg1;
- (void)_touchDown:(id)arg1;
- (void)setEnabled:(BOOL)enabled;
- (void)setSelected:(BOOL)selected;
- (void)setHighlighted:(BOOL)highlighted;
- (id)initWithFrame:(CGRect)frame;

@end