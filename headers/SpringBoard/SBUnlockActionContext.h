@interface SBUnlockActionContext : NSObject
- (id)initWithLockLabel:(NSString *)lockLabel shortLockLabel:(NSString *)label unlockAction:(void (^)())action identifier:(NSString *)id;
- (void)setDeactivateAwayController:(BOOL)deactivate;
@end