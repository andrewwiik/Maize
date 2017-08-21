#import <SpringBoard/SBLockScreenActionContext.h>

@interface SBLockScreenActionContext (Private)
- (id)initWithLockLabel:(NSString *)lockLabel shortLockLabel:(NSString *)label action:(void (^)())action identifier:(NSString *)id;
- (void)setDeactivateAwayController:(BOOL)deactivate;
@end