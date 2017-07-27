
#import "MZEModuleMetadata.h"

@interface MZEModuleRepository : NSObject {
	NSArray *_directoryURLs;
	NSMutableArray *_enabledIdentifiers;
	NSMutableArray *_disabledIdentifiers;
	NSMutableDictionary<NSString *, MZEModuleMetadata *> *_moduleMetadataByIdentifier;
	NSString *_enabledKey;
	NSString *_disabledKey;
	NSString *_settingsIdentifier;
	NSString *_settingsFilePath;
}
@property (nonatomic, retain, readwrite) NSArray *directoryURLs;
@property (nonatomic, retain, readwrite) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain, readwrite) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, MZEModuleMetadata *> *moduleMetadataByIdentifier;
+ (instancetype)repositoryWithDefaults;
+ (BOOL)isDebug;
+ (NSArray *)_defaultModuleDirectories;
+ (NSString *)settingsFilePath;
+ (NSString *)settingsIdentifier;
+ (NSString *)enabledKey;
+ (NSString *)disabledKey;
+ (NSArray *)defaultEnabledIdentifiers;
+ (NSArray *)defaultDisabledIdentifiers;
- (id)_initWithDirectoryURLs:(NSArray *)directoryURLs;
- (void)updateAllModuleMetadata;
- (void)loadSettings;
- (void)_saveSettings;
@end