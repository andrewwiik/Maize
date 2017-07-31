#import "MZEDoNotDisturbModule.h"
@implementation MZEDoNotDisturbModule

- (id)init {
	self = [super init];
	if (self) {
		_settingsGateway = [[NSClassFromString(@"BBSettingsGateway") alloc] initWithQueue:dispatch_get_main_queue()];
		[self _observeSystemNotifications];
	}
	return self;
}

- (void)_observeSystemNotifications {

	__weak MZEDoNotDisturbModule *self_ = self;
	[_settingsGateway getBehaviorOverridesEnabledWithCompletion:^(BOOL enabled) {
		__strong MZEDoNotDisturbModule *strongSelf = self_;
		_dndIsEnabled = enabled;
		[strongSelf refreshState];
	}];

	__weak MZEDoNotDisturbModule *self__ = self;
	[_settingsGateway setActiveBehaviorOverrideTypesChangeHandler:^(BOOL enabled) {
		__strong MZEDoNotDisturbModule *strongSelf = self__;
		_dndIsEnabled = enabled;
		[strongSelf refreshState];
	}];
}

- (CAPackage *)glyphPackage {
	NSURL *packageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"MPAVScreenMirroring" withExtension:@"ca"];
    return [CAPackage packageWithContentsOfURL:packageURL type:kCAPackageTypeCAMLBundle options:nil error:nil];
}

- (NSString *)statusText {
	return @"";
}

- (NSString *)glyphState {
	if ([self isSelected]) {
		return @"on";
	} else {
		return @"off";
	}
}

- (BOOL)isSelected {
	return _dndIsEnabled;
}
 
- (void)setSelected:(BOOL)isSelected {
	[super setSelected:isSelected];
	if (isSelected != _dndIsEnabled) {
		_dndIsEnabled = isSelected;
		if (isSelected) {
			[_settingsGateway setBehaviorOverrideStatus:1 source:1];
		} else {
			[_settingsGateway setBehaviorOverrideStatus:2 source:1];
		}
	}
	//[self refreshState];
}

@end