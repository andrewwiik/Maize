#import "MZECAPackageView.h"

@implementation MZECAPackageView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.userInteractionEnabled = NO;
	}
	return self;
}

- (id)init {
	self = [super initWithFrame:CGRectZero];
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
		// self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,package.rootLayer.bounds.size.width,package.rootLayer.bounds.size.height);

		_packageLayer = package.rootLayer;
		_package = package;
	}

}
- (void)setStateName:(NSString *)name {
	if (_stateController && _packageLayer) {
		CGFloat transitionSpeed = 1.0;
		if ([name containsString:@"|"]) {
			NSArray* split = [name componentsSeparatedByString:@"|"];
			if ([split count] == 2) {
				transitionSpeed = (CGFloat)[(NSString *)split[1] floatValue];
				name = (NSString *)split[0];
			}
		}

		CAState *state = [_packageLayer stateWithName:name];
		[_stateController setState:state ofLayer:_packageLayer transitionSpeed:transitionSpeed];
	}

}
- (void)layoutSubviews {
	[super layoutSubviews];
	if (_packageLayer) {
		[_packageLayer setPosition:UIRectGetCenter(self != nil ? self.bounds : CGRectZero)];
	}
}
@end