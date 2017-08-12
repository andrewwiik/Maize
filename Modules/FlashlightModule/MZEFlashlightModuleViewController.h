#import <MaizeUI/MZEModuleSliderView.h>
#import <MaizeUI/MZEToggleViewController.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>

@interface MZEFlashlightModuleViewController : MZEToggleViewController <MZEContentModuleContentViewController> {
	MZEModuleSliderView *_sliderView;
}
@property (nonatomic, retain, readwrite) MZEModuleSliderView *sliderView;
- (id)init;
- (void)viewDidLoad;
- (void)_sliderValueDidChange:(MZEModuleSliderView *)sliderView;
- (CGFloat)preferredExpandedContentHeight;
- (CGFloat)preferredExpandedContentWidth;
- (void)willTransitionToExpandedContentMode:(BOOL)willTransition;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

- (BOOL)shouldBeginTransitionToExpandedContentModule;
@end