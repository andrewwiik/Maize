#import "MZEFlipSwitchProvider.h"

#import <FlipSwitch/FSSwitchPanel+Private.h>


@implementation MZEFlipSwitchProvider

+ (NSArray<NSString *> *)possibleIdentifiers {
	return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] sortedSwitchIdentifiers];
}

+ (id<MZEContentModule>)moduleForIdentifier:(NSString *)identifier {
	return [[MZEFlipSwitchToggleModule alloc] initWithSwitchIdentifier:identifier];
}

+ (UIImage *)glyphForIdentifier:(NSString *)identifier {
	return [[[NSClassFromString(@"FSSwitchPanel") sharedPanel] imageOfSwitchState:FSSwitchStateIndeterminate controlState:UIControlStateNormal forSwitchIdentifier:identifier usingTemplate:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier {
	return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:identifier] ? [[NSClassFromString(@"FSSwitchPanel") sharedPanel] primaryColorForSwitchIdentifier:identifier] : [UIColor grayColor];;
}

+ (NSString *)displayNameForIdentifier:(NSString *)identifier {
	return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] titleForSwitchIdentifier:identifier];
}

+ (NSInteger)rowsForIdentifier:(NSString *)identifier {
	return 1;
}

+ (NSInteger)columnsForIdentifier:(NSString *)identifier {
	return 1;
}
@end