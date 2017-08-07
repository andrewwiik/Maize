#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : NSObject
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
+ (instancetype)_sharedInstanceCreatingIfNeeded:(BOOL)ifNeeded;
- (CCUIControlCenterViewController *)_controlCenterViewController;
@end