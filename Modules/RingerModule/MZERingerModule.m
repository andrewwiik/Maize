#import "MZERingerModule.h"
@implementation MZERingerModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.ringer"];
	if (self) {

	}
	return self;
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Ringer" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (BOOL)isReversed {
	return YES;
}

- (NSString *)glyphState {
	if ([self isSelected]) {
		return @"silent";
	} else {
		return @"ringer";
	}
}
@end