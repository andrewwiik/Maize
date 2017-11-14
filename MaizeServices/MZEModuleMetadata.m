#import "MZEModuleMetadata.h"
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIColor+Private.h>
#import "macros.h"

@implementation MZEModuleMetadata
- (id)initWithBundlePath:(NSURL *)bundlePath {
	self = [super init];
	if (self) {
		_isProvider = NO;
		_bundlePath = bundlePath;
		NSDictionary *installedBundleInfo = (__bridge NSDictionary *)CFBundleCopyInfoDictionaryInDirectory((__bridge CFURLRef)self.bundlePath);
		CFBundleRef bundle = CFBundleCreate(kCFAllocatorDefault, (__bridge CFURLRef)self.bundlePath);

		if (bundle) {
			_displayName = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(bundle, (__bridge CFStringRef)@"CFBundleDisplayName");
			if (!_displayName) {
				_displayName = @"FAILED_TO_LOAD_NAME";
			}

			NSString *iconBackgroundColorString = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(bundle, (__bridge CFStringRef)@"MZEGlyphBackgroundColor");
			BOOL shouldTemplate = NO;
			if (iconBackgroundColorString) {
				_settingsIconBackgroundColor = colorFromHexString(iconBackgroundColorString);
				shouldTemplate = YES;
			} else {
				_settingsIconBackgroundColor = [UIColor grayColor];
			}

			_settingsIconGlyph = [UIImage imageNamed:@"SettingsIcon" inBundle:[NSBundle bundleWithURL:bundlePath]];

			if (_settingsIconGlyph && shouldTemplate) {
				_settingsIconGlyph = [_settingsIconGlyph imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else {
				_settingsIconGlyph = [UIImage imageNamed:@"SettingsIconFull" inBundle:[NSBundle bundleWithURL:bundlePath]];
			}

		}

		if (installedBundleInfo) {

			if ([installedBundleInfo objectForKey:@"CFBundleIdentifier"]) {
				_identifier = (NSString *)[installedBundleInfo objectForKey:@"CFBundleIdentifier"];
			}

			if (!_identifier) {
				return nil;
			}

			if ([installedBundleInfo objectForKey:@"MZEModuleSize"]) {
				if ([[installedBundleInfo objectForKey:@"MZEModuleSize"] isKindOfClass:[NSDictionary class]]) {
					NSDictionary *moduleSize = (NSDictionary *)[installedBundleInfo objectForKey:@"MZEModuleSize"];
					if ([moduleSize objectForKey:@"width"]) {
						_moduleWidth = (NSNumber *)[moduleSize objectForKey:@"width"];
					}

					if ([moduleSize objectForKey:@"height"]) {
						_moduleHeight = (NSNumber *)[moduleSize objectForKey:@"height"];
					}
				}
			}



			if (!_moduleWidth) {
				_moduleWidth = [NSNumber numberWithInt:1];
			}

			if (!_moduleHeight) {
				_moduleHeight = [NSNumber numberWithInt:1];
			}



			if ([installedBundleInfo objectForKey:@"UIDeviceFamily"]) {
				if ([[installedBundleInfo objectForKey:@"UIDeviceFamily"] isKindOfClass:[NSArray class]]) {
					_supportedDeviceFamilies = (NSArray *)[installedBundleInfo objectForKey:@"UIDeviceFamily"];
				}
			}

			if (!_supportedDeviceFamilies) {
				_supportedDeviceFamilies = [NSArray new];
			}
		}
	}
	return self;
}

- (id)initWithInfoDictionary:(NSDictionary *)info andBundlePath:(NSURL *)bundlePath {
	self = [super init];
	if (self) {
		_isProvider = YES;
		_bundlePath = bundlePath;
		NSDictionary *installedBundleInfo = info;
		if (installedBundleInfo) {

			if ([installedBundleInfo objectForKey:@"BundleIdentifier"]) {
				_identifier = (NSString *)[installedBundleInfo objectForKey:@"BundleIdentifier"];
			}

			if ([installedBundleInfo objectForKey:@"ProviderClass"]) {
				_providerClass = (NSString *)[installedBundleInfo objectForKey:@"ProviderClass"];
			}

			if ([installedBundleInfo objectForKey:@"DisplayName"]) {
				_displayName = (NSString *)[installedBundleInfo objectForKey:@"DisplayName"];
			}

			if ([installedBundleInfo objectForKey:@"GlyphBackgroundColor"]) {
				_settingsIconBackgroundColor = (UIColor *)[installedBundleInfo objectForKey:@"GlyphBackgroundColor"];
			} else {
				_settingsIconBackgroundColor = [UIColor grayColor];
			}

			if ([installedBundleInfo objectForKey:@"GlyphImage"]) {
				_settingsIconGlyph = (UIImage *)[installedBundleInfo objectForKey:@"GlyphImage"];
			}

			if (!_identifier || !_providerClass) {
				return nil;
			}

			if ([installedBundleInfo objectForKey:@"Width"]) {
				_moduleWidth = (NSNumber *)[installedBundleInfo objectForKey:@"Width"];
			}

			if ([installedBundleInfo objectForKey:@"Height"]) {
				_moduleWidth = (NSNumber *)[installedBundleInfo objectForKey:@"Height"];
			}

			if (!_moduleWidth) {
				_moduleWidth = [NSNumber numberWithInt:1];
			}

			if (!_moduleHeight) {
				_moduleHeight = [NSNumber numberWithInt:1];
			}

			// if ([installedBundleInfo objectForKey:@"UIDeviceFamily"]) {
			// 	if ([[installedBundleInfo objectForKey:@"UIDeviceFamily"] isKindOfClass:[NSArray class]]) {
			// 		_supportedDeviceFamilies = (NSArray *)[installedBundleInfo objectForKey:@"UIDeviceFamily"];
			// 	}
			// }

			if (!_supportedDeviceFamilies) {
				_supportedDeviceFamilies = [NSArray new];
			}
		}
	}
	return self;
}

- (BOOL)isProvider {
	return _isProvider;
}

- (Class<MZEModuleProviderDelegate>)providerClass {
	if (_providerClass) {
		return (Class<MZEModuleProviderDelegate>)NSClassFromString(_providerClass);
	}
	return nil;
}
@end