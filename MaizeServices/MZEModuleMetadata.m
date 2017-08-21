#import "MZEModuleMetadata.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation MZEModuleMetadata
- (id)initWithBundlePath:(NSURL *)bundlePath {
	self = [super init];
	if (self) {
		_isProvider = NO;
		_bundlePath = bundlePath;
		NSDictionary *installedBundleInfo = (__bridge NSDictionary *)CFBundleCopyInfoDictionaryInDirectory((__bridge CFURLRef)self.bundlePath);
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