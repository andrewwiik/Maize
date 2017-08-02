#import "MZEContentModuleBackgroundView.h"
#import <QuartzCore/CALayer+Private.h>

@implementation MZEContentModuleBackgroundView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setAlpha:0];
		[[self layer] setHitTestsAsOpaque:YES];
	}
	return self;
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
	[super setUserInteractionEnabled:enabled];
	[[self layer] setHitTestsAsOpaque:enabled == NO];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	for (UIView *view in [self subviews]) {
		view.frame = self.bounds;
	}
}
@end