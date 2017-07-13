#import <QuartzCore/CAPackage+Private.h>
#import "MZELabeledRoundButton.h"

@interface MZELabeledRoundButtonViewController : UIViewController
{
    BOOL _labelsVisible;
    BOOL _toggleStateOnTap;
    BOOL _enabled;
    BOOL _inoperative;
    NSString *_subtitle;
    CAPackage *_glyphPackage;
    NSString *_glyphState;
    UIImage *_glyphImage;
    UIColor *_highlightColor;
    MZELabeledRoundButton *_buttonContainer;
    UIControl *_button;
}

@property(retain, nonatomic,readwrite) UIControl *button; // @synthesize button=_button;
@property(retain, nonatomic,readwrite) MZELabeledRoundButton *buttonContainer; // @synthesize buttonContainer=_buttonContainer;
@property(retain, nonatomic,readwrite) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(nonatomic, getter=isInoperative,readwrite) BOOL inoperative; // @synthesize inoperative=_inoperative;
@property(nonatomic, getter=isEnabled,readwrite) BOOL enabled; // @synthesize enabled=_enabled;
@property(nonatomic,readwrite) BOOL toggleStateOnTap; // @synthesize toggleStateOnTap=_toggleStateOnTap;
@property(nonatomic,readwrite) BOOL labelsVisible; // @synthesize labelsVisible=_labelsVisible;
@property(retain, nonatomic,readwrite) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(copy, nonatomic,readwrite) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic,readwrite) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;
@property(copy, nonatomic,readwrite) NSString *subtitle; // @synthesize subtitle=_subtitle;
- (void)loadView;
@property(copy, nonatomic,readwrite) NSString *title; // @synthesize title=_title;
- (void)buttonTapped:(id)arg1;
- (id)initWithGlyphPackage:(CAPackage *)arg1 highlightColor:(UIColor *)arg2;
- (id)initWithGlyphImage:(UIImage *)arg1 highlightColor:(UIColor *)arg2;

@end