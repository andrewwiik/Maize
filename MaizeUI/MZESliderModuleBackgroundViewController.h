
#import <QuartzCore/CAPackage+Private.h>
#import "MZECAPackageView.h"

@interface MZESliderModuleBackgroundViewController : UIViewController
{
    UIImageView *_headerImageView;
    MZECAPackageView *_packageView;
}

- (void)setGlyphState:(NSString *)glyphState;
- (void)setGlyphPackage:(CAPackage *)glyphPackage;
- (void)setGlyphImage:(UIImage *)glyphImage;
- (void)viewWillLayoutSubviews;
- (void)viewDidLoad;

@end