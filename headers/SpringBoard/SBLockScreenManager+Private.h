#import <SpringBoard/SBLockScreenViewControllerBase.h>
#import <SpringBoard/SBLockScreenManager.h>
@interface SBLockScreenManager (Private)
+ (instancetype)sharedInstance;
- (BOOL)isUILocked;
- (SBLockScreenViewControllerBase *)lockScreenViewController;
@end