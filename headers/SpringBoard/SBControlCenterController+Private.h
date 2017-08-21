//#import <SpringBoard/SBControlCenterController.h>
#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
+ (instancetype)_sharedInstanceCreatingIfNeeded:(BOOL)ifNeeded;
- (CCUIControlCenterViewController *)_controlCenterViewController;
- (void)dismissAnimated:(BOOL)animated completion:(/*^block*/id)completion;
- (void)presentAnimated:(BOOL)animated completion:(/*^block*/id)completion;
- (void)dismissAnimated:(BOOL)animated;
- (BOOL)isVisible;
@end