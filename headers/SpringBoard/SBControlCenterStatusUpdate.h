@interface SBControlCenterStatusUpdate : NSObject
+ (instancetype)statusUpdateWithString:(NSString *)string reason:(NSString *)reason;
@end