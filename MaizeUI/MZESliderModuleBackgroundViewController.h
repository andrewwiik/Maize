
#import <QuartzCore/CAPackage+Private.h>
#import "MZECAPackageView.h"
#import <QuartzCore/CAPackage+Private.h>

@interface MZESliderModuleBackgroundViewController : UIViewController
{
    UIImageView *_headerImageView;
    MZECAPackageView *_packageView;
    CAPackage *_package;
}

- (void)setGlyphState:(NSString *)glyphState;
- (void)setGlyphPackage:(CAPackage *)glyphPackage;
- (void)setGlyphImage:(UIImage *)glyphImage;
- (void)viewWillLayoutSubviews;
- (void)viewDidLoad;

@end