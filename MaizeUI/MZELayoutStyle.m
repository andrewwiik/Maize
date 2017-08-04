#import "MZELayoutStyle.h"
#import "MZELayoutOptions.h"

@implementation MZELayoutStyle
- (id)initWithSize:(CGSize)size isLandscape:(BOOL)isLandscape {
	self = [super init];
	if (self) {
		_isLandscape = isLandscape;
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

- (BOOL)isLandscape {
	return _isLandscape;
}
@end