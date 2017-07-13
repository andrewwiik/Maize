#import "MZECAPackageView.h"

@implementation MZECAPackageView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.userInteractionEnabled = NO;
	}
	return self;
}


- (void)setPackage:(CAPackage *)package {
	[self _setPackage:package];
}

- (void)_setPackage:(CAPackage *)package {
	if (_packageLayer) {
		[_packageLayer removeFromSuperlayer];
	}

	if (package.rootLayer) {
		[self.layer addSublayer:package.rootLayer];
		_stateController = [[CAStateController alloc] initWithLayer:package.rootLayer];
		package.rootLayer.geometryFlipped = YES;

		_packageLayer = package.rootLayer;
		_package = package;
	}

}
- (void)setStateName:(NSString *)name {
	if (_stateController && _packageLayer) {
		CAState *state = [_packageLayer stateWithName:name];
		[_stateController setState:state ofLayer:_packageLayer transitionSpeed:2];
	}

}
- (void)layoutSubviews {
	[super layoutSubviews];
	if (_packageLayer) {
		[_packageLayer setPosition:UIRectGetCenter(self != nil ? self.bounds : CGRectZero)];
	}
}
@end