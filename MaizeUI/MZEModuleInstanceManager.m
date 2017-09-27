#import "MZEModuleInstanceManager.h"
#import "MZEContentModule-Protocol.h"

@implementation MZEModuleInstanceManager
	@dynamic moduleInstances;

+ (instancetype)sharedInstance {
	static MZEModuleInstanceManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithRepository:[MZEModuleRepository repositoryWithDefaults]];
    });
    return _sharedInstance;
}

- (id)initWithRepository:(MZEModuleRepository *)repository {
	self = [super init];
	if (self) {

		if (!repository) return nil;

		_repository = repository;
		_moduleInstanceByIdentifier = [NSMutableDictionary new];
		[self _loadModuleInstances];
	}
	return self;
}

- (void)_loadModuleInstances {
	_enabledModuleIdentifiers = [NSSet setWithArray:_repository.allIdentifiers];
	for (NSString *identifier in _enabledModuleIdentifiers) {
		MZEModuleMetadata *metadata = _repository.moduleMetadataByIdentifier[identifier];
		if (metadata) {
			MZEModuleInstance *moduleInstance = [self _instantiateModuleWithMetadata:metadata];
			if (moduleInstance) {
				_moduleInstanceByIdentifier[identifier] = moduleInstance;
			}
		}
	}
}

// - (void)_reloadModuleInstances {
// 	_enabledModuleIdentifiers = [NSSet setWithArray:_repository.enabledIdentifiers];
// 	for (NSString *identifier in _enabledModuleIdentifiers) {
// 		MZEModuleMetadata *metadata = _repository.moduleMetadataByIdentifier[identifier];
// 		if (metadata) {
// 			MZEModuleInstance *moduleInstance = [self _instantiateModuleWithMetadata:metadata];
// 			if (moduleInstance) {
// 				_moduleInstanceByIdentifier[identifier] = moduleInstance;
// 			}
// 		}
// 	}
// }

- (MZEModuleInstance *)_instantiateModuleWithMetadata:(MZEModuleMetadata *)metadata {
	if (metadata) {
		if (![metadata isProvider]) {
			NSBundle *moduleBundle = [NSBundle bundleWithURL:metadata.bundlePath];
			if (moduleBundle) {
				BOOL isLoaded = [moduleBundle isLoaded];
				if (isLoaded) {
					Class principalClass = [moduleBundle principalClass];
					if ([principalClass conformsToProtocol:@protocol(MZEContentModule)]) {
						if ([principalClass respondsToSelector:@selector(isSupported)]) {
							if (![(Class<MZEContentModule>)principalClass isSupported]) {
								[moduleBundle unload];
								return nil;
							}
						}

						id<MZEContentModule> module = [[principalClass alloc] init];
						MZEModuleInstance *moduleInstance = [[MZEModuleInstance alloc] initWithMetadata:metadata module:module];
						
						return moduleInstance;
					} else {
						[moduleBundle unload];
					}
				} else {

					NSError *error = nil;
					BOOL didLoad = [moduleBundle loadAndReturnError:&error];

					if (didLoad) {

						Class principalClass = [moduleBundle principalClass];
						if ([principalClass conformsToProtocol:@protocol(MZEContentModule)]) {
							if ([principalClass respondsToSelector:@selector(isSupported)]) {
								if (![(Class<MZEContentModule>)principalClass isSupported]) {
									[moduleBundle unload];
									return nil;
								}
							}

							id<MZEContentModule> module = [[principalClass alloc] init];
							MZEModuleInstance *moduleInstance = [[MZEModuleInstance alloc] initWithMetadata:metadata module:module];
							
							return moduleInstance;
						} else {
							[moduleBundle unload];
						}
					} else {
						HBLogError(@"LOADING MAIZE MODULE ERROR: %@", error);
					}
				}
			}
		} else {
			NSBundle *moduleBundle = [NSBundle bundleWithURL:metadata.bundlePath];
			if (moduleBundle) {
				BOOL isLoaded = [moduleBundle isLoaded];
				if (isLoaded) {

					id<MZEContentModule> module = [[metadata providerClass] moduleForIdentifier:metadata.identifier];
					MZEModuleInstance *moduleInstance = [[MZEModuleInstance alloc] initWithMetadata:metadata module:module];
					return moduleInstance;
					// Class principalClass = [moduleBundle principalClass];
					// if ([principalClass conformsToProtocol:@protocol(MZEContentModule)]) {
					// 	// if ([principalClass respondsToSelector:@selector(isSupported)]) {
					// 	// 	if (![(Class<MZEContentModule>)principalClass isSupported]) {
					// 	// 		[moduleBundle unload];
					// 	// 		return nil;
					// 	// 	}
					// 	// }

					// 	id<MZEContentModule> module = [[principalClass alloc] init];
					// 	MZEModuleInstance *moduleInstance = [[MZEModuleInstance alloc] initWithMetadata:metadata module:module];
						
					// 	return moduleInstance;
					// } else {
					// 	[moduleBundle unload];
					// }
				} else {

					NSError *error = nil;
					BOOL didLoad = [moduleBundle loadAndReturnError:&error];

					if (didLoad) {

						id<MZEContentModule> module = [[metadata providerClass] moduleForIdentifier:metadata.identifier];
						MZEModuleInstance *moduleInstance = [[MZEModuleInstance alloc] initWithMetadata:metadata module:module];
						return moduleInstance;
					
					} else {
						HBLogError(@"LOADING MAIZE MODULE ERROR: %@", error);
					}
				}
			}
		}
	}
	return nil;
}


- (NSArray<MZEModuleInstance *> *)moduleInstances {
	return [_moduleInstanceByIdentifier allValues];
}
@end