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
    CGSize _buttonSize;

}

@property(retain, nonatomic, readwrite) UILabel *subtitleLabel; // @synthesize subtitleLabel=_subtitleLabel;
@property(retain, nonatomic, readwrite) UILabel *titleLabel; // @synthesize titleLabel=_titleLabel;
@property(retain, nonatomic, readwrite) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(retain, nonatomic, readwrite) MZERoundButton *buttonView; // @synthesize buttonView=_buttonView;
@property(nonatomic, readwrite) BOOL labelsVisible; // @synthesize labelsVisible=_labelsVisible;
@property(copy, nonatomic, readwrite) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic, readwrite) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;
@property(retain, nonatomic, readwrite) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(copy, nonatomic, readwrite) NSString *subtitle; // @synthesize subtitle=_subtitle;
@property(copy, nonatomic, readwrite) NSString *title; // @synthesize title=_title;
@property (nonatomic, assign, readwrite) CGSize buttonSize; // @synthesize buttonSize=_buttonSize;
@property (nonatomic, strong) NSLayoutConstraint *buttonWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *buttonHeightConstraint;
- (void)_layoutLabels;
- (void)buttonTapped:(id)arg1;
- (CGSize)intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)size;
- (void)layoutSubviews;
- (id)initWithGlyphPackage:(CAPackage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithGlyphImage:(UIImage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithHighlightColor:(UIColor *)arg1;

@end