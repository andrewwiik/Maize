#import "MZEModuleCollectionView.h"
#import "MZELayoutViewLayoutSource-Protocol.h"

@implementation MZEModuleCollectionView
- (id)initWithLayoutSource:(id<MZELayoutViewLayoutSource>)layoutSource frame:(CGRect)frame {
	self = [super initWithLayoutSource:layoutSource frame:frame];
	if (self) {

	}
	return self;
}

- (BOOL)clipsToBounds {
	return NO;
}

- (void)setClipsToBounds:(BOOL)clips {
	[super setClipsToBounds:NO];
}
@end