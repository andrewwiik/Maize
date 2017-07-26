#import "UIView+MZE.h"

@implementation UIView (MZE)
- (CGFloat)_cornerRadius {
	return self.layer.cornerRadius;
}
- (void)_setCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = cornerRadius;
	if (cornerRadius > 0) {
		self.clipsToBounds=YES;
	}
}
@end