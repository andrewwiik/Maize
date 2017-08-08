#import "MZEFlashlightModule.h"
@implementation MZEFlashlightModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.flashlight"];
	if (self) {

	}
	return self;
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.0];
}

@end