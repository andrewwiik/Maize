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
	return nil;
}
+ (UIColor *)glyphBackgroundColorForIdentifier:(NSString *)identifier {
	return nil;
}
+ (NSInteger)rowsForIdentifier:(NSString *)identifier {
	return 1;
}
+ (NSInteger)columnsForIdentifier:(NSString *)identifier {
	return 1;
}
@end