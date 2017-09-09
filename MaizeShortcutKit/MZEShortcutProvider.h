#import "MZEShortcutItem.h"

@class SBIconController;

@interface MZEShortcutProvider : NSObject {
	SBIconController *_iconController;
}
@property (nonatomic, retain, readwrite) SBIconController *iconController;
+ (instancetype)sharedInstance;
- (NSArray<MZEShortcutItem *> *)shortcutsForBundleIdentifier:(NSString *)bundleIdentifier;
@end