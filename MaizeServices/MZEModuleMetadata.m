#import "MZEModuleMetadata.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation MZEModuleMetadata
- (id)initWithBundlePath:(NSURL *)bundlePath {
	self = [super init];
	if (self) {
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
@end