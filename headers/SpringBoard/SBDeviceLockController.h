@interface SBDeviceLockController : NSObject
+ (instancetype)sharedController;
- (BOOL)isPasscodeLocked;
@end