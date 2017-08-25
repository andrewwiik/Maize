#import <SpringBoard/SBUnlockActionContext.h>
#import <SpringBoard/SBAlert.h>
#import "SBLockScreenActionContext+Private.h"

@interface SBLockScreenViewControllerBase : SBAlert 
- (void)setCustomUnlockActionContext:(SBUnlockActionContext *)context;
- (void)setCustomLockScreenActionContext:(SBLockScreenActionContext *)customContext;

- (void)setUnlockActionContext:(SBUnlockActionContext *)context; //iOS 8+
- (void)setPasscodeLockVisible:(BOOL)visibile animated:(BOOL)animated completion:(void (^)())completion;
@end