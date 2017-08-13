#import <MaizeUI/MZEFlipSwitchToggleModule.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>
#import <MaizeUI/MZESliderModuleBackgroundViewController.h>


@interface MZEFlashlightModule : MZEFlipSwitchToggleModule {
	NSBundle *_moduleBundle;
	UIImage *_cachedSelectedIconGlyph;
	UIImage *_cachedIconGlyph;
	MZESliderModuleBackgroundViewController *_backgroundViewController;
}

@property(readonly, nonatomic) UIViewController *backgroundViewController;
- (id)init;
- (UIColor *)selectedColor;
- (UIImage *)iconGlyph;
- (UIImage *)selectedIconGlyph;
- (BOOL)isSelected;
- (BOOL)isEnabled;
- (void)setSelected:(BOOL)isSelected;
- (void)switchStateDidChange:(NSNotification *)notification;
- (UIViewController *)backgroundViewController;
- (UIViewController<MZEContentModuleContentViewController> *)contentViewController;
@end