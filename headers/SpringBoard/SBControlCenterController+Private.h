#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
+ (instancetype)_sharedInstanceCreatingIfNeeded:(BOOL)ifNeeded;
- (CCUIControlCenterViewController *)_controlCenterViewController;
- (void)dismissAnimated:(BOOL)arg1 completion:(/*^block*/id)arg2 ;
- (void)presentAnimated:(BOOL)arg1 completion:(/*^block*/id)arg2 ;
@end