#import "MZELowPowerModule.h"
@implementation MZELowPowerModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.low-power"];
	if (self) {

	}
	return self;
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"LowPower" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (NSString *)glyphState {
	if ([self isSelected]) {
		return @"enabled";
	} else {
		return @"disabled";
	}
}

@end