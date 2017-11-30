//#import <SpringBoard/SBControlCenterController.h>
#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
+ (instancetype)_sharedInstanceCreatingIfNeeded:(BOOL)ifNeeded;
- (CCUIControlCenterViewController *)_controlCenterViewController;
- (void)dismissAnimated:(BOOL)animated completion:(id)completion;
- (void)presentAnimated:(BOOL)animated completion:(id)completion;
- (void)dismissAnimated:(BOOL)animated;
- (BOOL)isVisible;
- (void)_updateRevealPercentage:(CGFloat)percentage;
//- (UIViewController *)_controlCenterViewController;
@end