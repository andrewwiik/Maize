#import "MZEConnectivityAirplaneViewController.h"

@implementation MZEConnectivityAirplaneViewController
	@synthesize airplaneModeEnabled = _airplaneModeEnabled;

- (id)init {
	UIImage *glyphImage = [UIImage imageNamed:@"AirplaneGlyph" inBundle:[NSBundle bundleForClass:[self class]]];
	UIColor *highlightColor = [UIColor systemOrangeColor];
	self = [super initWithGlyphImage:glyphImage highlightColor:highlightColor];
	if (self) {
		_bundle = [NSBundle bundleForClass:[self class]];
	}
	return self;
}

- (void)dealloc {
	[_airplaneModeController setDelegate:nil];
	_airplaneModeController = nil;
}

- (void)buttonTapped:(UIControl *)button {
	[self _toggleState];
	[super buttonTapped:button];
}

- (NSString *)displayName {
	return [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_AIRPLANE_MODE_NAME" value:@"Airplane Mode" table:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!_airplaneModeController) {
		_airplaneModeController = [[NSClassFromString(@"RadiosPreferences") alloc] init];
		[_airplaneModeController setDelegate:self];
	}
	[self _updateState];
}

- (void)airplaneModeChanged {
	[self _updateState];
}

- (void)_setAirplaneModeEnabled:(BOOL)enabled {
	_airplaneModeEnabled = enabled;
	[self setEnabled:[self _stateWithEffectiveOverrides]];
}

- (void)_updateState {
	[self _setAirplaneModeEnabled:[_airplaneModeController airplaneMode]];
}

- (BOOL)_toggleState {
	BOOL enabled = [self _isAirplaneModeEnabled] == 0;
	[_airplaneModeController setAirplaneMode:enabled];
	[self _setAirplaneModeEnabled:enabled];
	return YES;
}

- (BOOL)_stateWithEffectiveOverrides {
	return _airplaneModeEnabled;
}

- (BOOL)_isStateOverridden {
	return NO;
}

- (BOOL)_isAirplaneModeEnabled {
	return _airplaneModeEnabled;
}

@end