#import "MZEFlipSwitchProvider.h"

#import <FlipSwitch/FSSwitchPanel+Private.h>



NSArray *idsToIgnore = nil;
@implementation MZEFlipSwitchProvider

+ (NSArray<NSString *> *)possibleIdentifiers {

	if (!idsToIgnore) {
		idsToIgnore = @[@"com.a3tweaks.switch.record-screen", 
								 @"com.a3tweaks.switch.do-not-disturb", 
								 @"com.a3tweaks.switch.flashlight",
								 @"com.a3tweaks.switch.low-power",
								 @"com.a3tweaks.switch.ringer",
								 @"com.a3tweaks.switch.rotation",
								 @"com.a3tweaks.switch.rotation-lock",
								 @"com.CC.ScreenRecordSwitch"];
	}
	
	NSMutableArray *allIdentifiers = [[[NSClassFromString(@"FSSwitchPanel") sharedPanel] sortedSwitchIdentifiers] mutableCopy];

	for (NSString *identifier in idsToIgnore) {
		[allIdentifiers removeObject:identifier];
	}

	return [allIdentifiers copy];

	//return [[NSClassFromString(@"FSSwitchPanel") sharedPanel] sortedSwitchIdentifiers];
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