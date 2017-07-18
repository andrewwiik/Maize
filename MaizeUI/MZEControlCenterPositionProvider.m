#import "MZEControlCenterPositionProvider.h"

@implementation MZEControlCenterPositionProvider
- (id)initWithLayoutStyle:(MZELayoutStyle *)layoutStyle orderIdentifiers:(NSArray<NSString *> *)orderedIdentifiers orderedSize:(NSArray<NSString *> *)orderSizes {
	self = [super init];
	if (self) {

	}
	return self;
}
- (CGRect)positionForIdentifier:(NSString *)identifier {
	return CGRectZero;
}
- (void)regenerateAllFrames {

}
@end