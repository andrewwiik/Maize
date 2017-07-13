#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

extern NSString * const PolusGlyphsChangedNotification;
extern NSString * const PolusSettingsChangedNotification;

typedef NS_ENUM(NSInteger, PLGlyphSize) {
	PLGlyphSizeTopShelf,
	PLGlyphSizeBottomShelf,
	PLGlyphSizeSmall,
	PLGlyphSizeNormal
};

typedef NS_ENUM(NSInteger, PLViewMode) {
	PLViewModeTopShelf,
	PLViewModeBottomShelf
};

typedef NS_ENUM(NSInteger, PLBackgroundMode) {
	PLBackgroundModeSquare = 1,
	PLBackgroundModeCircular = 2,
	PLBackgroundModeNone = 3
};

@interface PLAppsController : NSObject
{

	NSMutableDictionary *_prefsDict;
	NSCache *_imageCache;
	NSCache *_glyphInfoCache;

	NSBundle *_templateBundle;

	NSMutableDictionary *_glyphBundles;

	NSMutableArray *_sortedBundleIdentifiers;

	NSMutableDictionary *_identifiersToModules;
}

@property (nonatomic, retain) NSMutableDictionary *glyphsForBundles;

+ (instancetype)sharedInstance;

- (void)preloadGlyphs;

- (void)refreshInfo;
- (void)saveInfo;
- (void)updateSectionsForShelfDict:(NSMutableDictionary *)shelfDict;

- (NSMutableArray *)glyphBundleIdentifiers;
- (void)setGlyphBundleIdentifiers:(NSMutableArray *)sortedIdentifiers;

- (NSMutableDictionary *)glyphBundles;

- (NSMutableArray *)visibleAppsForViewMode:(PLViewMode)viewMode;
- (NSMutableArray *)hiddenAppsForViewMode:(PLViewMode)viewMode;

- (void)setVisibleApps:(NSArray *)apps forViewMode:(PLViewMode)viewMode;
- (void)setHiddenApps:(NSArray *)apps forViewMode:(PLViewMode)viewMode;

- (NSArray *)glyphIdentifiersForBundleWithIdentifier:(NSString *)bundleIdentifier;

- (NSDictionary *)appGlyphInfoForAppIdentifier:(NSString *)appIdentifier withViewMode:(PLViewMode)viewMode;
- (UIImage *)glyphOfSize:(PLGlyphSize)size forAppIdentifier:(NSString *)appIdentifier withViewMode:(PLViewMode)viewMode;

- (UIImage *)glyphInBundleWithIdentifier:(NSString *)bundleIdentifier withGlyphIdentifier:(NSString *)glyphID;
- (void)setGlyphIdentifier:(NSString *)glyphIdentifier withBundleIdentifier:(NSString *)bundleIdentifier forAppIdentifier:(NSString *)appIdentifier withViewMode:(PLViewMode)viewMode;

- (id)moduleForIdentifier:(NSString *)identifier;
@end