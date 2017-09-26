
#import "MZEModuleMetadata.h"
#import "MZEModuleProvider.h"

@interface MZEModuleRepository : NSObject {
	NSArray *_directoryURLs;
	NSArray *_providerURLs;
	NSMutableArray *_enabledIdentifiers;
	NSMutableArray *_disabledIdentifiers;
	//NSMutableArray *_allIdentifiers;
	NSMutableDictionary<NSString *, MZEModuleMetadata *> *_moduleMetadataByIdentifier;
	NSString *_enabledKey;
	NSString *_disabledKey;
	NSString *_settingsIdentifier;
	NSString *_settingsFilePath;
}
@property (nonatomic, retain, readwrite) NSArray *directoryURLs;
@property (nonatomic, retain, readwrite) NSArray *providerURLs;
@property (nonatomic, retain, readwrite) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain, readwrite) NSMutableArray *disabledIdentifiers;
@property (nonatomic, readonly) NSMutableArray *allIdentifiers;
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, MZEModuleMetadata *> *moduleMetadataByIdentifier;
+ (instancetype)repositoryWithDefaults;
+ (BOOL)isDebug;
+ (NSArray *)_defaultModuleDirectories;
+ (NSArray *)_defaultProviderDirectories;
+ (NSString *)settingsFilePath;
+ (NSString *)settingsIdentifier;
+ (NSString *)enabledKey;
+ (NSString *)disabledKey;
+ (NSString *)settingsChangedNotificationName;
+ (NSArray *)defaultEnabledIdentifiers;
+ (NSArray *)defaultDisabledIdentifiers;
- (id)_initWithDirectoryURLs:(NSArray *)directoryURLs providerURLs:(NSArray *)providerURLs;
- (void)updateAllModuleMetadata;
- (void)loadSettings;
- (void)_saveSettings;
- (id)allIdentifiers;
- (MZEModuleMetadata *)metadataForIdentifier:(NSString *)identifier;
@end