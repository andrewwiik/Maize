#import "MZEContentModuleContainerView.h"

@implementation MZEContentModuleContainerView
@synthesize moduleIdentifier=_moduleIdentifier;
- (id)initWithModuleIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_moduleIdentifier = identifier;
	}
	return self;
}
@end