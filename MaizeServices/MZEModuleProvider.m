#import "MZEModuleProvider.h"

@implementation MZEModuleProvider
	@synthesize provider = _provider;

- (id)initWithBundlePath:(NSURL *)bundlePath {

	self = [super init];
	if (self) {
		_bundlePath = bundlePath;
		_possibleIdentifiers = [NSArray new];
		NSBundle *providerBundle = [NSBundle bundleWithURL:bundlePath];
		NSError *error = nil;
		BOOL didLoad = [providerBundle loadAndReturnError:&error];
		
		if (didLoad) {

			Class principalClass = [providerBundle principalClass];

			if ([principalClass conformsToProtocol:@protocol(MZEModuleProviderDelegate)]) {
				_provider = principalClass;
				_possibleIdentifiers = [_provider possibleIdentifiers];
			}
		} else if (error) {
			HBLogError(@"Couldn't Load Module Provider Error: %@", error);
		}
	}
	return self;
}


- (NSDictionary *)infoDictionaryForIdentifier:(NSString *)identifier {
	if ([_possibleIdentifiers containsObject:identifier]) {
		NSInteger moduleWidth = [_provider columnsForIdentifier:identifier];
		NSInteger moduleHeight = [_provider rowsForIdentifier:identifier];


		NSDictionary *info = @{
			@"BundleIdentifier": identifier,
			@"ProviderClass": NSStringFromClass(_provider),
			@"Width": @(moduleWidth),
			@"Height": @(moduleHeight)
		};

		return info;
	}

	return nil;
}
@end