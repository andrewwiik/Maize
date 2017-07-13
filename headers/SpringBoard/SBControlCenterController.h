#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : NSObject
+ (instancetype)sharedInstance;
+ (id)sharedInstanceIfExists;
- (CCUIControlCenterViewController *)_controlCenterViewController;
@end