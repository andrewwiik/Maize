#import "MZERoundButton.h"
#import <QuartzCore/CAPackage+Private.h>


@interface MZELabeledRoundButton : UIView
{
    BOOL _labelsVisible;
    NSString *_title;
    NSString *_subtitle;
    UIImage *_glyphImage;
    CAPackage *_glyphPackage;
    NSString *_glyphState;
    MZERoundButton *_buttonView;
    UIColor *_highlightColor;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}

@property(retain, nonatomic) UILabel *subtitleLabel; // @synthesize subtitleLabel=_subtitleLabel;
@property(retain, nonatomic) UILabel *titleLabel; // @synthesize titleLabel=_titleLabel;
@property(retain, nonatomic) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(retain, nonatomic) MZERoundButton *buttonView; // @synthesize buttonView=_buttonView;
@property(nonatomic) BOOL labelsVisible; // @synthesize labelsVisible=_labelsVisible;
@property(copy, nonatomic) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;
@property(retain, nonatomic) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(copy, nonatomic) NSString *subtitle; // @synthesize subtitle=_subtitle;
@property(copy, nonatomic) NSString *title; // @synthesize title=_title;
- (void)_layoutLabels;
- (void)buttonTapped:(id)arg1;
- (CGSize)intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (void)layoutSubviews;
- (id)initWithGlyphPackage:(CAPackage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithGlyphImage:(UIImage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithHighlightColor:(UIColor *)arg1;

@end