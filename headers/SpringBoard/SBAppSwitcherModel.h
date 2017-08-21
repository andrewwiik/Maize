@interface SBAppSwitcherModel : NSObject

+ (instancetype)sharedInstance;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end