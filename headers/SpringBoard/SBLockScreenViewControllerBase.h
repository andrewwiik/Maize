#import <SpringBoard/SBUnlockActionContext.h>
#import <SpringBoard/SBAlert.h>
@interface SBLockScreenViewControllerBase : SBAlert 
- (void)setCustomUnlockActionContext:(SBUnlockActionContext *)context;
- (void)setCustomLockScreenActionContext:(id)arg1;

- (void)setUnlockActionContext:(SBUnlockActionContext *)context; //iOS 8+
- (void)setPasscodeLockVisible:(BOOL)visibile animated:(BOOL)animated completion:(void (^)())completion;
@end