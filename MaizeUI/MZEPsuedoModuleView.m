#import "MZEPsuedoModuleView.h"
#import <UIKit/UIView+Private.h>
#import "MZELayoutOptions.h"
#import <QuartzCore/CALayer+Private.h>

@implementation MZEPsuedoModuleView
- (id)initWithIdentifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_moduleIdentifier = identifier;
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 1.0;
		self.opaque = TRUE;
		//self.clipsToBounds = YES;
		if (self._continuousCornerRadius < 1.0f) {
			self._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		}

		self.layer.cornerRadius = [MZELayoutOptions regularContinuousCornerRadius];
		self.layer.cornerContentsCenter = [MZELayoutOptions regularCornerCenter];
	}
	return self;
}
@end