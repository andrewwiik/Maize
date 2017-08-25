#import "MZEShortcutProvider.h"

@implementation MZEShortcutProvider

+ (instancetype)sharedInstance {
	static MZEShortcutProvider *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MZEShortcutProvider alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
	self = [super init];
	if (self) {

	}
	return self;
}
@end