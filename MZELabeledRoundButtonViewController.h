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

@property(retain, nonatomic) UIControl *button; // @synthesize button=_button;
@property(retain, nonatomic) MZELabeledRoundButton *buttonContainer; // @synthesize buttonContainer=_buttonContainer;
@property(retain, nonatomic) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(nonatomic, getter=isInoperative) BOOL inoperative; // @synthesize inoperative=_inoperative;
@property(nonatomic, getter=isEnabled) BOOL enabled; // @synthesize enabled=_enabled;
@property(nonatomic) BOOL toggleStateOnTap; // @synthesize toggleStateOnTap=_toggleStateOnTap;
@property(nonatomic) BOOL labelsVisible; // @synthesize labelsVisible=_labelsVisible;
@property(retain, nonatomic) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(copy, nonatomic) NSString *glyphState; // @synthesize glyphState=_glyphState;
@property(retain, nonatomic) CAPackage *glyphPackage; // @synthesize glyphPackage=_glyphPackage;
@property(copy, nonatomic) NSString *subtitle; // @synthesize subtitle=_subtitle;
- (void)loadView;
@property(copy, nonatomic) NSString *title; // @dynamic title;
- (void)buttonTapped:(id)arg1;
- (id)initWithGlyphPackage:(id)arg1 highlightColor:(id)arg2;
- (id)initWithGlyphImage:(id)arg1 highlightColor:(id)arg2;

@end