#import <MaizeUI/MZEModuleSliderView.h>
#import <MaizeUI/MZEToggleViewController.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import <AVFoundation/AVFlashlight.h>
#import <MaizeUI/MZEToggleModule.h>

extern NSString *const FlashlightLevelKey;

@interface MZEFlashlightModuleViewController : MZEToggleViewController <MZEContentModuleContentViewController> {
	MZEModuleSliderView *_sliderView;
	NSUserDefaults *_userDefaults;
}
@property (nonatomic, retain, readwrite) MZEModuleSliderView *sliderView;
+ (instancetype)sharedFlashlightModule;
+ (AVFlashlight *)currentFlashlight;
- (id)init;
- (void)viewDidLoad;
- (void)_sliderValueDidChange:(MZEModuleSliderView *)sliderView;
- (void)updateToggleState;
- (CGFloat)preferredExpandedContentHeight;
- (CGFloat)preferredExpandedContentWidth;
- (void)willTransitionToExpandedContentMode:(BOOL)willTransition;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)buttonTapped:(UIControl *)button forEvent:(id)event;
- (void)newFlashlightMade:(NSNotification *)notification;
- (BOOL)shouldBeginTransitionToExpandedContentModule;
@end