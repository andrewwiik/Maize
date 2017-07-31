
#import "MZEAudioModuleViewControllerDelegate-Protocol.h"
#import <MaizeUI/MZEContentModule-Protocol.h>
#import <MaizeUI/MZESliderModuleBackgroundViewController.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import <QuartzCore/CAPackage+Private.h>
#import "MZEAudioModuleViewController.h"

@interface MZEAudioModule : NSObject <MZEContentModule, MZEAudioModuleViewControllerDelegate>
{
    MZEAudioModuleViewController *_moduleViewController;
    MZESliderModuleBackgroundViewController *_backgroundViewController;
}

@property(readonly, nonatomic) UIViewController *backgroundViewController;
@property(readonly, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController;

- (NSString *)_audioGlyphStateForVolumeLevel:(CGFloat)volumeLevel;
- (CAPackage *)_audioGlyphPackage;
- (void)audioModuleViewController:(id)moduleViewController volumeDidChange:(float)volume;

@end

