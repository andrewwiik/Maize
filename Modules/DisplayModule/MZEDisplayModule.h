
#import "MZEDisplayModuleViewControllerDelegate-Protocol.h"
#import <MaizeUI/MZEContentModule-Protocol.h>
#import <MaizeUI/MZESliderModuleBackgroundViewController.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import <QuartzCore/CAPackage+Private.h>
#import "MZEDisplayModuleViewController.h"

@interface MZEDisplayModule : NSObject <MZEContentModule, MZEDisplayModuleViewControllerDelegate>
{
    MZEDisplayModuleViewController *_moduleViewController;
    MZESliderModuleBackgroundViewController *_backgroundViewController;
}

@property(readonly, nonatomic) UIViewController *backgroundViewController;
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;

- (NSString *)_brightnessGlyphStateForBrightnessLevel:(float)brightnessLevel;
- (CAPackage *)_brightnessGlyphPackage;
- (void)displayModuleViewController:(id)moduleViewController brightnessDidChange:(float)brightness;

@end

