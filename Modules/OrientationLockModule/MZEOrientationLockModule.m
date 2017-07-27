#import "MZEOrientationLockModule.h"
@implementation MZEOrientationLockModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.rotation-lock"];
	if (self) {

	}
	return self;
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"OrientationLock" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (NSString *)glyphState {
	if ([self isSelected]) {
		return @"locked";
	} else {
		return @"unlocked";
	}
}

@end