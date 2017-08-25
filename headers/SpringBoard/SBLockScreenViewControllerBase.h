#import <SpringBoard/SBUnlockActionContext.h>
#import <SpringBoard/SBAlert.h>
#import "SBLockscreenActionContext+Private.h"

@interface SBLockScreenViewControllerBase : SBAlert 
- (void)setCustomUnlockActionContext:(SBUnlockActionContext *)context;
- (void)setCustomLockScreenActionContext:(SBLockscreenActionContext *)customContext;

- (void)setUnlockActionContext:(SBUnlockActionContext *)context; //iOS 8+
- (void)setPasscodeLockVisible:(BOOL)visibile animated:(BOOL)animated completion:(void (^)())completion;
@end