#import <MaizeUI/MZEFlipSwitchToggleModule.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>


@interface MZEFlashlightModule : MZEFlipSwitchToggleModule {
	
}
- (id)init;
- (UIColor *)selectedColor;
- (UIViewController<MZEContentModuleContentViewController> *)contentViewController;
@end