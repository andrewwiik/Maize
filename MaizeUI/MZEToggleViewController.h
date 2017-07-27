#import <QuartzCore/CAPackage+Private.h>
#import "MZEButtonModuleViewController.h"
#import "MZEContentModuleContentViewController-Protocol.h"

@class MZEToggleModule;
@interface MZEToggleViewController : MZEButtonModuleViewController <MZEContentModuleContentViewController>
{
    UIImageView *_glyphImageView;
    UIImage *_glyphImage;
    UIImage *_selectedGlyphImage;
    UIColor *_selectedColor;
    CAPackage *_glyphPackage;
    NSString *_glyphState;
    MZEToggleModule *_module;
}

@property(nonatomic, readwrite) MZEToggleModule *module; // @synthesize module=_module;
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;
- (BOOL)shouldBeginTransitionToExpandedContentModule;
- (void)viewDidLoad;
- (void)refreshState;
- (void)buttonTapped:(UIControl *)button forEvent:(id)event;
- (void)setModule:(MZEToggleModule *)module;
- (void)setAllowsHighlighting:(BOOL)allowsHighlighting;
@end