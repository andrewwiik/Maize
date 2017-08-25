#import "MZEShortcutItem.h"

@interface MZEShortcutProvider {
	SBIconController *_iconController;
}
@property (nonatomic, retain, readwrite) SBIconController *iconController;
+ (instancetype)sharedInstance;
- (NSArray<MZEShortcutItem *> *)shortcutsForBundleIdentifier:(NSString *)bundleIdentifier;
@end