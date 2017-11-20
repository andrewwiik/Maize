#import "MZEContentModuleContentViewController-Protocol.h"
#import "MZEButtonModuleView.h"
#import <QuartzCore/CAPackage+Private.h>

@interface MZEButtonModuleViewController : UIViewController <MZEContentModuleContentViewController>
{
    MZEButtonModuleView *_buttonModuleView;
    BOOL _expanded;
}

@property(readonly, nonatomic, getter=isExpanded) BOOL expanded; // @synthesize expanded=_expanded;
@property(nonatomic,retain, readwrite) MZEButtonModuleView *buttonModuleView;
- (void)willTransitionToExpandedContentMode:(BOOL)arg1;
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;
- (void)viewDidLoad;
- (void)buttonTapped:(UIControl *)button forEvent:(id)event;
@property(readonly, nonatomic) UIControl *buttonView;
@property(nonatomic, getter=isSelected) BOOL selected;
@property(nonatomic, getter=isEnabled) BOOL enabled;
@property(copy, nonatomic) NSString *glyphState;
@property(retain, nonatomic) CAPackage *glyphPackage;
@property(retain, nonatomic) UIColor *selectedGlyphColor;
@property(retain, nonatomic) UIImage *selectedGlyphImage;
@property(retain, nonatomic) UIColor *glyphColor;
@property(retain, nonatomic) UIImage *glyphImage;
- (void)setAllowsHighlighting:(BOOL)allowsHighlighting;

@end