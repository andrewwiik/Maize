#import <SpringBoard/SBApplication.h>

@interface SBApplicationController : NSObject
+ (SBApplicationController *)sharedInstance;
- (SBApplication *)applicationWithDisplayIdentifier:(NSString *)identifier;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)identifier;
- (NSArray<SBApplication *> *)allApplications;
@end