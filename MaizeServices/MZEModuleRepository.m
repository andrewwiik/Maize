#import "MZEModuleRepository.h"

@implementation MZEModuleRepository
+ (instancetype)repositoryWithDefaults {
	static MZEModuleRepository *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MZEModuleRepository alloc] _initWithDirectoryURLs:[MZEModuleRepository _defaultModuleDirectories]];
    });
    return _sharedInstance;
}

+ (NSArray *)_defaultModuleDirectories {
	return [NSArray arrayWithObjects:[NSURL fileURLWithPath:@"/Library/Maize/Bundles/"], nil];
}

+ (NSString *)settingsFilePath {
	return @"/var/mobile/Library/Preferences/com.ioscreatix.Maize.plist";
}

+ (NSString *)settingsIdentifier {
	return @"com.ioscreatix.Maize";
}

+ (NSString *)enabledKey {
	return @"EnabledIdentifiers13";
}

+ (NSString *)disabledKey {
	return @"DisabledIdentifiers13";
}

+ (NSArray *)defaultEnabledIdentifiers {
	NSMutableArray *defaultEnabledIdentifiers = [NSMutableArray new];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.DoNotDisturbModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.ConnectivityModule"];
	return [defaultEnabledIdentifiers copy];
}

+ (NSArray *)defaultDisabledIdentifiers {
	NSMutableArray *defaultDisabledIdentifiers = [NSMutableArray new];
	//[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.DoNotDisturbModule"];
	return [defaultDisabledIdentifiers copy];
}

- (id)_initWithDirectoryURLs:(NSArray *)directoryURLs {
	self = [super init];
	if (self) {
		_moduleMetadataByIdentifier = [NSMutableDictionary new];
		_directoryURLs = directoryURLs;
		_settingsIdentifier = [MZEModuleRepository settingsIdentifier];
		_settingsFilePath = [MZEModuleRepository settingsFilePath];
		_enabledKey = [MZEModuleRepository enabledKey];
		_disabledKey = [MZEModuleRepository disabledKey];
		[self updateAllModuleMetadata];
	}
	return self;
}
- (void)updateAllModuleMetadata {
	for (NSURL *repositoryURL in _directoryURLs) {
		NSError *error = nil;
		NSArray *bundleURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:repositoryURL
															includingPropertiesForKeys:nil
                   															   options:(NSDirectoryEnumerationSkipsHiddenFiles)
                   																 error:&error];

		if (bundleURLs) {
			for (NSURL *bundleURL in bundleURLs) {
				if ([[bundleURL pathExtension] caseInsensitiveCompare:@"bundle"] == NSOrderedSame) {
					MZEModuleMetadata *metadata = [[MZEModuleMetadata alloc] initWithBundlePath:bundleURL];
					if (metadata) {
						_moduleMetadataByIdentifier[metadata.identifier] = metadata;
					}
				}
			}
		} else {
			HBLogError(@"%@", error);
		}
	}

	if (!_enabledIdentifiers | !_disabledIdentifiers) {
		[self loadSettings];
	} else {
		[self _saveSettings];
		[self loadSettings];
	}
}

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

	NSArray *originalEnabled = [settings objectForKey:_enabledKey];
	NSArray *originalDisabled = [settings objectForKey:_disabledKey];
	
	NSMutableArray *allIdentifiers = [[_moduleMetadataByIdentifier allKeys] mutableCopy];

	if (!originalEnabled || [originalEnabled count] == 0) {
		originalEnabled = [MZEModuleRepository defaultEnabledIdentifiers];
	}

	if (!originalDisabled || ([originalDisabled count] == 0 && [originalEnabled count] < [allIdentifiers count])) {
		originalDisabled = [MZEModuleRepository defaultDisabledIdentifiers];
	}


	if (!_disabledIdentifiers) {
		_disabledIdentifiers = [NSMutableArray new];
	}
	if (!_enabledIdentifiers) {
		_enabledIdentifiers = [NSMutableArray new];
	}

	for  (NSString *identifier in originalEnabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[_disabledIdentifiers removeObject:identifier];
			[_enabledIdentifiers addObject:identifier];
		} else {
			[_enabledIdentifiers removeObject:identifier];
		}
	}
	for (NSString *identifier in originalDisabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[_disabledIdentifiers addObject:identifier];
		} else {
			[_disabledIdentifiers removeObject:identifier];
		}
	}

	for (NSString *identifier in allIdentifiers) {
		[_disabledIdentifiers addObject:identifier];
	}

	[self _saveSettings];
}

- (void)_saveSettings {
	if (_settingsIdentifier && (_enabledKey || _disabledKey)) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		if (_enabledKey) {
			[dict setObject:self.enabledIdentifiers forKey:_enabledKey];
		}
		if (_disabledKey) {
			[dict setObject:self.disabledIdentifiers forKey:_disabledKey];
		}
		CFPreferencesSetMultiple((CFDictionaryRef)dict, NULL, (__bridge CFStringRef)_settingsIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
		CFPreferencesAppSynchronize((__bridge CFStringRef)_settingsIdentifier);
	}

	if (_settingsFilePath) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:_settingsFilePath] ?: [NSMutableDictionary dictionary];
		if (_enabledKey) {
			[dict setObject:_enabledIdentifiers forKey:_enabledKey];
		}
		if (_disabledKey) {
			[dict setObject:self.disabledIdentifiers forKey:_disabledKey];
		}
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
		[data writeToFile:_settingsFilePath atomically:YES];
	}

	// We can handle this shit later

	// if (self.notificationName) {
	// 	[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
 //                                                    object:nil
 //                                                  userInfo:nil];
	// }
}
@end