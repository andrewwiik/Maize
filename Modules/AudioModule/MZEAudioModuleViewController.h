#import <MediaPlayerUI/MPVolumeControllerDelegate-Protocol.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import "MZEAudioModuleViewControllerDelegate-Protocol.h"
#import <MaizeUI/MZEModuleSliderView.h>
#import <MediaPlayerUI/MPVolumeController.h>
#import <QuartzCore/CALayer+Private.h>

@interface MZEAudioModuleViewController : UIViewController <MPVolumeControllerDelegate, MZEContentModuleContentViewController>
{
    __weak id <MZEAudioModuleViewControllerDelegate> _delegate;
    MZEModuleSliderView *_sliderView;
    MPVolumeController *_volumeController;
    BOOL _expanded;
}

@property(retain, nonatomic, readwrite) MPVolumeController *volumeController;
@property(retain, nonatomic, readwrite) MZEModuleSliderView *sliderView; 
@property(nonatomic) __weak id <MZEAudioModuleViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(nonatomic) BOOL allowsInPlaceFiltering;
@property(readonly, nonatomic) CALayer *punchOutRootLayer;
@property(readonly, nonatomic, getter=isGroupRenderingRequired) BOOL groupRenderingRequired;
@property(readonly, nonatomic, getter=isContentClippingRequired) BOOL contentClippingRequired;
@property(readonly, nonatomic) CGFloat preferredExpandedContentWidth;
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;
@property(readonly, nonatomic) float currentVolume;

- (void)volumeController:(MPVolumeController *)volumeController volumeValueDidChange:(float)volume;
- (void)_sliderValueDidChange:(MZEModuleSliderView *)slider;
- (void)willResignActive;
- (void)willBecomeActive;
- (void)willTransitionToExpandedContentMode:(BOOL)willTransition;
- (void)setGlyphState:(NSString *)glyphState;
- (void)setGlyphPackage:(CAPackage *)glyphPackage;
- (void)setOtherGlyphPackage:(CAPackage *)otherGlyphPackage;
//- (void)viewWillTransitionToSize:(struct CGSize)arg1 withTransitionCoordinator:(id)arg2;
- (void)viewDidLoad;
- (void)loadView;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;

@end

