#import "MZEShortcutItem.h"

@interface MZEShortcutProvider
+ (instancetype)sharedInstance;
- (NSArray<MZEShortcutItem *> *)shortcutsForBundleIdentifier:(NSString *)bundleIdentifier;
@end