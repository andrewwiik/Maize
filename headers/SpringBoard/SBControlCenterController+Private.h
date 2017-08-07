#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
+ (instancetype)_sharedInstanceCreatingIfNeeded:(BOOL)ifNeeded;
- (CCUIControlCenterViewController *)_controlCenterViewController;
@end