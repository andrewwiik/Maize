#import <MaizeUI/MZEModuleSliderView.h>
#import <MaizeUI/MZEToggleViewController.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import <AVFoundation/AVFlashlight.h>
#import <MaizeUI/MZEToggleModule.h>
#import "CCUIFlashlightSetting+MZE.h"

extern NSString *const FlashlightLevelKey;

@interface MZEFlashlightModuleViewController : MZEToggleViewController <MZEContentModuleContentViewController> {
	MZEModuleSliderView *_sliderView;
	NSUserDefaults *_userDefaults;
	CCUIFlashlightSetting *_flashlightSetting;
}
@property (nonatomic, retain, readwrite) MZEModuleSliderView *sliderView;
@property (nonatomic, retain, readwrite) CCUIFlashlightSetting *flashlightSetting;
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
- (BOOL)shouldMaskToBounds;
//- (void)fakeHideSlider:(BOOL)should;

#pragma mark passing touches to the toggle
- (void)_dragExit:(id)arg1;
- (void)_dragEnter:(id)arg1;
- (void)_touchUpOutside:(id)arg1;
- (void)_touchUpInside:(id)arg1;
- (void)_touchDown:(id)arg1;
@end