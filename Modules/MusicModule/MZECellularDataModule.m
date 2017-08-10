#import "MZECellularDataModule.h"
@implementation MZECellularDataModule

- (id)init {
	self = [super initWithSwitchIdentifier:@"com.a3tweaks.switch.cellular-data"];
	if (self) {

	}
	return self;
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"CellularData" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (NSString *)glyphState {
	if ([self isSelected]) {
		return @"seeking";
	} else {
		return @"off";
	}
}
@end