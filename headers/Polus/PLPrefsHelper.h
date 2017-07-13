#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

@interface PLPrefsHelper : NSObject {
@private
	NSBundle *_ownBundle;
	NSMutableDictionary *_prefsDict;
	BOOL _iPad;
}

+ (instancetype)sharedInstance;

- (NSMutableDictionary *)prefsDict;

- (NSMutableDictionary *)topShelfPrefs;
- (NSMutableDictionary *)bottomShelfPrefs;

- (void)verifyButtonsInShelfDict:(NSMutableDictionary *)shelfDict;

- (void)reloadPrefs;
- (void)savePrefs;

- (UIImage *)ownImageNamed:(NSString *)name;
- (NSString *)ownStringForKey:(NSString *)key;
- (NSBundle *)ownBundle;

@end
