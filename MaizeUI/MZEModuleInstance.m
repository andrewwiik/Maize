#import "MZEModuleInstance.h"

@implementation MZEModuleInstance
	@synthesize module=_module;
	@synthesize metadata=_metadata;

- (id)initWithMetadata:(MZEModuleMetadata *)metadata module:(id<MZEContentModule>)module {
	self = [super init];
	if (self) {
		_metadata = metadata;
		_module = module;
	}
	return self;
}
@end