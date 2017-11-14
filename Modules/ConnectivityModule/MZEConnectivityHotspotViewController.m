#import "MZEConnectivityHotspotViewController.h"
#import <Flipswitch/FSSwitchPanel.h>
#import <FlipSwitch/FSSwitchPanel+Private.h>

MZEConnectivityHotspotViewController *hotspotController;

static void StateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if (hotspotController) {
		[hotspotController _updateState];
	}
	//[hotspotController _updateState];
}



@implementation MZEConnectivityHotspotViewController
	@synthesize hotspotModeEnabled = _hotspotModeEnabled;

- (id)init {
	UIImage *glyphImage = [UIImage imageNamed:@"HotspotGlyph" inBundle:[NSBundle bundleForClass:[self class]]];
	UIColor *highlightColor = [UIColor systemGreenColor];
	self = [super initWithGlyphImage:glyphImage highlightColor:highlightColor];
	if (self) {
		_bundle = [NSBundle bundleForClass:[self class]];
		hotspotController = self;
		_switchIdentifier = @"com.a3tweaks.switch.hotspot";
	}
	return self;
}

- (void)dealloc {
	//[_hotspotModeController setDelegate:nil];
	[_airplaneModeController setDelegate:nil];
	_airplaneModeController = nil;
	_hotspotModeController = nil;
}

- (void)buttonTapped:(UIControl *)button {
	[self _toggleState];
	[super buttonTapped:button];
}

- (NSString *)displayName {
	return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_HOTSPOT_NAME" value:@"" table:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!_hotspotModeController) {
		_hotspotModeController = [[NSClassFromString(@"CCUIPersonalHotspotSetting") alloc] init];
		CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), StateChanged, StateChanged, CFSTR("SBNetworkTetheringStateChangedNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchStateDidChange:) name:FSSwitchPanelSwitchStateChangedNotification object:nil];
		//[_hotspotModeController setDelegate:self];
	}
	if (!_airplaneModeController) {
		_airplaneModeController = [[NSClassFromString(@"RadiosPreferences") alloc] init];
		[_airplaneModeController setDelegate:self];
	}
	[self _updateState];


}

- (void)hotspotModeChanged {
	[self _updateState];
}

- (void)_setHotspotModeEnabled:(BOOL)enabled {
	//_isEnabled = enabled;
	[self setEnabled:[self _stateWithEffectiveOverrides]];
}

- (void)_updateState {
	//[_hotspotModeController _updateState];
	_currentState = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] stateForSwitchIdentifier:_switchIdentifier];
	_isEnabled = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] switchWithIdentifierIsEnabled:_switchIdentifier];
	[self _setHotspotModeEnabled:[self _isHotspotModeEnabled]];
	[self setInoperative:[_airplaneModeController airplaneMode]];
	[self setSubtitle:[self subtitleText]];
}

- (BOOL)_toggleState {
	BOOL isSelected = [self _isHotspotModeEnabled] == 0;
	[[NSClassFromString(@"FSSwitchPanel") sharedPanel] setState:isSelected ? FSSwitchStateOn : FSSwitchStateOff forSwitchIdentifier:_switchIdentifier];
	[self _setHotspotModeEnabled:isSelected];
	return YES;
}

- (BOOL)_stateWithEffectiveOverrides {

	if ([_airplaneModeController airplaneMode]) {
		return NO;
	}

	switch (_currentState) {
		case FSSwitchStateOff:
			return NO;
		case FSSwitchStateOn:
			return YES;
		default:
			return NO;
	}
}

- (NSString *)subtitleText {
	if ([_airplaneModeController airplaneMode]) {
		return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_AIRPLANE_MODE_NAME" value:@"AIRPLANE_MODE_NAME" table:nil];
	} else return [super subtitleText];
}

- (BOOL)_isStateOverridden {
	return NO;
}

- (BOOL)_isHotspotModeEnabled {
	if (_hotspotModeEnabled) {

	}

	// if ([_airplaneModeController airplaneMode]) {
	// 	return NO;
	// }

	switch (_currentState) {
		case FSSwitchStateOff:
			return NO;
		case FSSwitchStateOn:
			return YES;
		default:
			return NO;
	}
}

- (void)airplaneModeChanged {
	[self _updateState];
}

// - (void)setSelected:(BOOL)isSelected {
// 	BOOL isReversed = NO;
// 	[[NSClassFromString(@"FSSwitchPanel") sharedPanel] setState:isSelected ? (isReversed ? FSSwitchStateOff : FSSwitchStateOn) : (isReversed ? FSSwitchStateOn : FSSwitchStateOff) forSwitchIdentifier:_switchIdentifier];
// 	//[_viewController setSelected:isSelected];
// 	//[super setSelected:isSelected];
// }


- (void)switchStateDidChange:(NSNotification *)notification
{
	NSString *changedIdentifier = [notification.userInfo objectForKey:FSSwitchPanelSwitchIdentifierKey];
	if ([changedIdentifier isEqual:_switchIdentifier] || !changedIdentifier) {
		_isEnabled = [[FSSwitchPanel sharedPanel] switchWithIdentifierIsEnabled:_switchIdentifier];
		_currentState = [[NSClassFromString(@"FSSwitchPanel") sharedPanel] stateForSwitchIdentifier:_switchIdentifier];
		//self.enabled = [[FSSwitchPanel sharedPanel] switchWithIdentifierIsEnabled:switchIdentifier];
		[self _updateState];
	}
}

+ (BOOL)isSupported {
	return YES;
}

@end