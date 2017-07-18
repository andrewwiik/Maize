#import "MZELayoutStyle.h"
#import "MZELayoutOptions.h"

@implementation MZELayoutStyle
- (id)initWithSize:(CGSize)size {
	self = [super init];
	if (self) {
		BOOL isLandscape = size.width > size.height;
		if (isLandscape) {
			self.rows = 3;
			self.columns = -1;
		} else {
			self.columns = 4;
			self.rows = -1;
		}

		self.spacing = [MZELayoutOptions itemSpacingSize];
		self.inset = [MZELayoutOptions edgeInsetSize];
		self.moduleSize = [MZELayoutOptions edgeSize];
	}
	return self;
}
@end