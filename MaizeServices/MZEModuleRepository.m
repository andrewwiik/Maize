#import "MZEModuleRepository.h"

@implementation MZEModuleRepository
+ (instancetype)repositoryWithDefaults {
	MZEModuleRepository *repository = [[MZEModuleRepository alloc] _initWithDirectoryURLs:[MZEModuleRepository _defaultModuleDirectories]];
	return repository;
}

+ (NSArray *)_defaultModuleDirectories {
	return [NSArray arrayWithObject:[NSURL fileURLWithPath:@"/Library/Maize/Bundles/"], nil];
}

+ (NSString *)settingsFilePath {
	return @"/var/mobile/Library/Preferences/com.rpetrich.flipcontrolcenter.plist";
}

+ (NSString *)settingsIdentifier {
	return @"com.ioscreatix.Maize";
}

+ (NSString *)enabledKey {
	return @"EnabledIdentifiers";
}

+ (NSString *)disabledKey {
	return @"DisabledIdentifiers";
}

+ (NSArray *)defaultEnabledIdentifiers {
	NSMutableArray *defaultEnabledIdentifiers = [NSMutableArray new];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.DoNotDisturbModule"];
	return [defaultEnabledIdentifiers copy];
}

- (id)_initWithDirectoryURLs:(NSArray *)directoryURLs {
	self = [super init];
	if (self) {
		_directoryURLs = directoryURLs;
		_settingsIdentifier = [MZEModuleRepository settingsIdentifier];
		_settingsFilePath = [MZEModuleRepository settingsFilePath];
		_enabledKey = [MZEModuleRepository enabledKey];
		_disabledKey = [MZEModuleRepository disabledKey];
		[self updateAllModuleMetadata];
	}
}
- (void)updateAllModuleMetadata 
- (void)loadSettings {

	NSDictionary *settings;

	if (_settingsFilePath) {
		if (_settingsIdentifier) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)_settingsIdentifier);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)_settingsIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)_settingsIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			settings = [NSDictionary dictionaryWithContentsOfFile:_settingsFilePath];
		}
	}
}
- (void)reloadSettings;
@end