#import "MZECurrentActions.h"

static BOOL _isSliding = NO;

@implementation MZECurrentActions
+ (void)setIsSliding:(BOOL)isSliding {
	_isSliding = isSliding;
}

+ (BOOL)isSliding {
	return _isSliding;
}
@end