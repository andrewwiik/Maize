#import "MZEConnectivityModuleView.h"
#import "MZEConnectivityModuleViewController.h"

@implementation MZEConnectivityModuleView
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {

	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	if (self.layoutDelegate) {
		//[self.layoutDelegate layoutButtons];
	}
}
@end