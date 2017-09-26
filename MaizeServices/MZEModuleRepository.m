#import "MZEModuleRepository.h"

@implementation MZEModuleRepository
+ (instancetype)repositoryWithDefaults {
	static MZEModuleRepository *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MZEModuleRepository alloc] _initWithDirectoryURLs:[MZEModuleRepository _defaultModuleDirectories] providerURLs:[MZEModuleRepository _defaultProviderDirectories]];
    });
    return _sharedInstance;
}

+ (BOOL)isDebug {
	return NO;
}

+ (NSArray *)_defaultModuleDirectories {
	return [NSArray arrayWithObjects:[NSURL fileURLWithPath:@"/Library/Maize/Bundles/"], nil];
}

+ (NSArray *)_defaultProviderDirectories {
	return [NSArray arrayWithObjects:[NSURL fileURLWithPath:@"/Library/Maize/Providers/"], nil];
}

+ (NSString *)settingsFilePath {
	return @"/var/mobile/Library/Preferences/com.ioscreatix.Maize2.plist";
}

+ (NSString *)settingsIdentifier {
	return @"com.ioscreatix.Maize2";
}

+ (NSString *)enabledKey {
	return @"EnabledIdentifiers20";
}

+ (NSString *)disabledKey {
	return @"DisabledIdentifiers20";
}

+ (NSString *)settingsChangedNotificationName {
	return @"com.ioscreatix.maize.settingschanged";
}

+ (NSArray *)defaultEnabledIdentifiers {
	NSMutableArray *defaultEnabledIdentifiers = [NSMutableArray new];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.AudioModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.LowPowerModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.FlashlightModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.DoNotDisturbModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.OrientationLockModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.RingerModule"];
	[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.ScreenRecordingModule"];

	//[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.ConnectivityModule"];
	return [defaultEnabledIdentifiers copy];
}

+ (NSArray *)defaultDisabledIdentifiers {
	NSMutableArray *defaultDisabledIdentifiers = [NSMutableArray new];
	//[defaultEnabledIdentifiers addObject:@"com.ioscreatix.maize.DoNotDisturbModule"];
	return [defaultDisabledIdentifiers copy];
}

- (id)_initWithDirectoryURLs:(NSArray *)directoryURLs providerURLs:(NSArray *)providerURLs {
	self = [super init];
	if (self) {
		_moduleMetadataByIdentifier = [NSMutableDictionary new];
		_directoryURLs = directoryURLs;
		_providerURLs = providerURLs;
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

	for (NSURL *repositoryURL in _providerURLs) {
		NSError *error = nil;
		NSArray *bundleURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:repositoryURL
															includingPropertiesForKeys:nil
                   															   options:(NSDirectoryEnumerationSkipsHiddenFiles)
                   																 error:&error];

		if (bundleURLs) {
			for (NSURL *bundleURL in bundleURLs) {
				if ([[bundleURL pathExtension] caseInsensitiveCompare:@"bundle"] == NSOrderedSame) {
					MZEModuleProvider *provider = [[MZEModuleProvider alloc] initWithBundlePath:bundleURL];
					if (provider) {
						for (NSString *identifier in provider.possibleIdentifiers) {
							NSDictionary *info = [provider infoDictionaryForIdentifier:identifier];
							if (info) {
								MZEModuleMetadata *metadata = [[MZEModuleMetadata alloc] initWithInfoDictionary:info andBundlePath:bundleURL];
								if (metadata) {
									_moduleMetadataByIdentifier[metadata.identifier] = metadata;
								}
							}
						}
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

- (id)testStuff {

	for (NSURL *repositoryURL in _providerURLs) {
		NSError *error = nil;
		NSArray *bundleURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:repositoryURL
															includingPropertiesForKeys:nil
                   															   options:(NSDirectoryEnumerationSkipsHiddenFiles)
                   																 error:&error];

		if (bundleURLs) {
			for (NSURL *bundleURL in bundleURLs) {
				if ([[bundleURL pathExtension] caseInsensitiveCompare:@"bundle"] == NSOrderedSame) {
					MZEModuleProvider *provider = [[MZEModuleProvider alloc] initWithBundlePath:bundleURL];
					//return provider;
					if (provider) {
						for (NSString *identifier in provider.possibleIdentifiers) {
							NSDictionary *info = [provider infoDictionaryForIdentifier:identifier];
							//return info;
							if (info) {
								MZEModuleMetadata *metadata = [[MZEModuleMetadata alloc] initWithInfoDictionary:info andBundlePath:bundleURL];
								return metadata;
								if (metadata) {
									_moduleMetadataByIdentifier[metadata.identifier] = metadata;
								}
							}
						}
					}
				}
			}
		} else {
			HBLogError(@"%@", error);
		}
	}
	return nil;
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
		}

		if (!settings) {
			settings = [NSDictionary dictionaryWithContentsOfFile:_settingsFilePath];
		}
	}

	NSArray *originalEnabled = [settings objectForKey:_enabledKey];
	NSArray *originalDisabled = [settings objectForKey:_disabledKey];
	
	NSMutableArray *allIdentifiers = [[_moduleMetadataByIdentifier allKeys] mutableCopy];
	//_allIdentifiers = allIdentifiers;

	if (!originalEnabled || [originalEnabled count] == 0) {
		originalEnabled = [MZEModuleRepository defaultEnabledIdentifiers];
	}

	if (!originalDisabled || ([originalDisabled count] == 0 && [originalEnabled count] < [allIdentifiers count])) {
		originalDisabled = [MZEModuleRepository defaultDisabledIdentifiers];
	}


	//if (!_disabledIdentifiers) {
		_disabledIdentifiers = [[_moduleMetadataByIdentifier allKeys] mutableCopy];
	//}
	//if (!_enabledIdentifiers) {
		_enabledIdentifiers = [NSMutableArray new];
	//}

	for  (NSString *identifier in originalEnabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[_disabledIdentifiers removeObject:identifier];
			[_enabledIdentifiers addObject:identifier];
		} else {
			[_enabledIdentifiers removeObject:identifier];
		}
	}
	// for (NSString *identifier in originalDisabled) {
	// 	if ([allIdentifiers containsObject:identifier]) {
	// 		[allIdentifiers removeObject:identifier];
	// 		[_disabledIdentifiers addObject:identifier];
	// 	} else {
	// 		[_disabledIdentifiers removeObject:identifier];
	// 	}
	// }

	// for (NSString *identifier in allIdentifiers) {
	// 	[_disabledIdentifiers addObject:identifier];
	// }

	// if ([[self class] isDebug]) {
	// 	_enabledIdentifiers = [[_moduleMetadataByIdentifier allKeys] mutableCopy];
	// 	_disabledIdentifiers = [NSMutableArray new];
	// }

	//[self _saveSettings];
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
			[dict setObject:self.enabledIdentifiers forKey:_enabledKey];
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

- (MZEModuleMetadata *)metadataForIdentifier:(NSString *)identifier {
	return (MZEModuleMetadata *)_moduleMetadataByIdentifier[identifier];
}

- (id)allIdentifiers {
	if ([self isDebug]) {
		return [[_moduleMetadataByIdentifier allKeys] mutableCopy];
	} else return [[self class] defaultEnabledIdentifiers];
}
@end