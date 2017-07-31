#import "MZEContentModuleContainerView.h"
#import "MZEContentModuleContainerViewController.h"

@implementation MZEContentModuleContainerView
@synthesize moduleIdentifier=_moduleIdentifier;
- (id)initWithModuleIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_moduleIdentifier = identifier;
	}
	return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	if (self.viewDelegate) {
		[self.viewDelegate touchesBegan:touches withEvent:event];
	}

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	if (self.viewDelegate) {
		[self.viewDelegate touchesMoved:touches withEvent:event];
	}

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if (self.viewDelegate) {
		[self.viewDelegate touchesEnded:touches withEvent:event];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.maskView) {
		self.maskView = self.maskView;
	}
}
@end


	// UITouch *touch = [[event allTouches] anyObject];
 //    CGPoint touchLocation = [touch locationInView:self];
 //    _firstX = touchLocation.x;
 //    _firstY = touchLocation.y;
 //   if (_firstX & _firstX )

	// CGAffineTransformMakeScale